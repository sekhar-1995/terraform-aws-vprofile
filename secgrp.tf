resource "aws_security_group" "vprofile-bean-elb-sg" {
  name        = "vprofile-bean-elb-sg"
  description = "Security group for bean-elb"
  vpc_id      = module.vpc.vpc_id
  egress {
    from_port   = 0
    protocol    = "-1" //here -1 means all the protocol
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"] // all the outbound traffic allowed to go anywhere
  }

  ingress { // it the load balancer security group, so we will allow the connection on "80" port
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"] // all the outbound traffic allowed to go anywhere
  }
}

// Now we will write security group for bastion host
resource "aws_security_group" "vprofile-bastion-sg" {
  name        = "vprofile-bastion-sg"
  description = "Security group for bastionisioner ec2 instance"
  vpc_id      = module.vpc.vpc_id
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = [var.MYIP]
  }
}

//security group for ec2 instance in bean stalk environment


resource "aws_security_group" "vprofile-prod-sg" {
  name        = "vprofile-prod-sg"
  description = "Security group for beanstalk instances"
  vpc_id      = module.vpc.vpc_id
  egress {
    from_port   = 0
    protocol    = "-1" //here -1 means all the protocol
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"] // all the outbound traffic allowed to go anywhere
  }
  //ssh to beanstalk instance , this will be the part of private subnet. So we can not access it form public network. we can access it form bastion host.
  //bastion group will be the part of public network. Form their we will do ssh to beanstalk.
  ingress { // only the private connection form bastion host security group will allowed to this security group on port 22. so they keep tight
    // control on security groups
    from_port       = 22
    protocol        = "tcp"
    to_port         = 22
    security_groups = [aws_security_group.vprofile-bastion-sg.id]
  }
}

// this is the security group for backend services i.e rds, elastic cache, activemq
resource "aws_security_group" "vprofile-backend-sg" {
  name        = "vprofile-backend-sg"
  description = "Security group for RDS, active mq, elastic cache"
  vpc_id      = module.vpc.vpc_id
  egress {
    from_port   = 0
    protocol    = "-1" //here -1 means all the protocol
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"] // all the outbound traffic allowed to go anywhere
  }

  ingress {
    from_port       = 0
    protocol        = "-1"
    to_port         = 0
    security_groups = [aws_security_group.vprofile-prod-sg.id] // vprofile-backend-sg is the security group of beanstalk instance
  }

  ingress {
    from_port       = 3306
    protocol        = "tcp"
    to_port         = 3306
    security_groups = [aws_security_group.vprofile-bastion-sg.id]
  }
}

//these instances rds,activeMQ, elastic cache will interact with each other, so we ant to allow all traffic form its own security group id.

resource "aws_security_group_rule" "sec_group_allow_itself" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.vprofile-backend-sg.id // id of the security group that we want to update
  source_security_group_id = aws_security_group.vprofile-backend-sg.id //form which security group id you want to allow the connection. 
}

















