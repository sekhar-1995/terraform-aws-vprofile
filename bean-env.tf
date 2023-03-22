resource "aws_elastic_beanstalk_environment" "vprofile-bean-prod" {
  application         = aws_elastic_beanstalk_application.vprofile-prod.name
  name                = "vprofile-bean-prod"
  solution_stack_name = "64bit Amazon Linux 2 v4.3.5 running Tomcat 8.5 Corretto 11"
  //we can found this from aws beanstalk doccumentation on ""hssicorp--> now we will go to "solution-stalk-name "
  //--> click on "Amazon API Doccumentation"--> select tomcat version
  cname_prefix = "vprofile-prod-domain"
  setting {
    name      = "VPCId"
    namespace = "aws:ec2:vpc"
    value     = module.vpc.vpc_id
  }

  //Now we will put all setting for my Beanstalk Environment
  setting { //it will create elastic beanstalk role
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "aws-elasticbeanstalk-ec2-role"
  }

  setting { //it is used to create elastic beanstalk role.
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "false"
  }

  setting { //it is the settings for subnets.here we want to put all the instances in private subnets.
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]])
    //here we have used a "Terraform function" which is known as "join". this function can join list into a string
    //here we have list of subnets
    //here we want comma separated in the form of string. so here we have join all subnets with the help --
    //--of join function & subnets are separated by comma
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = join(",", [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]])
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.micro"
  }

  setting { //for keypair
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = aws_key_pair.vprofilekey.key_name
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "Availability Zones"
    value     = "Any 3"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "1"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "8"
  }

  setting { // it is thw name of the environment
    name      = "aws:elasticbeanstalk:application:environment"
    namespace = "environment"
    value     = "prod"
  }

  setting { //setting for logs
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "LOGGING-APPENDER"
    value     = "GRAYLOG"
  }

  setting { //setting form health monitoring
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateEnabled"
    value     = "true"
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateType"
    value     = "Health"
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "MaxBatchSize"
    value     = "1"
  }

  setting {
    namespace = "aws:elb:loadbalancer"
    name      = "CrossZone"
    value     = "true"
  }

  setting {
    name      = "StickinessEnabled"
    namespace = "aws:elasticbeanstalk:environment:process:default"
    value     = "true"
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "BatchSizeType"
    value     = "Fixed"
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "BatchSize"
    value     = "1"
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "DeploymentPolicy"
    value     = "Rolling"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = aws_security_group.vprofile-prod-sg.id
  }

  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "SecurityGroups"
    value     = aws_security_group.vprofile-bean-elb-sg.id
  }

  #till now we have done for all the setting

  //but there could be a bug. The "BUG" is this we are creating security group & then we creating--
  //-- beanstalk environment. First security group should get created & then beanstalk environment should get created--
  //-- because it is reffering. Most of the time it is intelligent to find that out, but sometimes there are some miss files--
  //--so we will create a dependency that first security group get crated & then beanstalk environment. i.e
  depends_on = [aws_security_group.vprofile-bean-elb-sg, aws_security_group.vprofile-prod-sg]

}
