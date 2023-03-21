variable "AWS_REGION" {
  default = "us-east-2"
}

variable "AMIS" {
  type = map(any)
  default = {
    us-east-2  = "ami-05502a22127df2492"
    us-east-1  = "ami-0557a15b87f6559cf"
    ap-south-1 = "ami-0f8ca728008ff5af4" // here we are updated AMIs of the ubuntu machine of different region
  }
}

variable "PRIV_KEY_PATH" {
  default = "vprofilekey" #this private key will be used for login
}

variable "PUB_KEY_PATH" {
  default = "vprofilekey.pub" #this public key will be used when we are lunching the Instance
}

variable "USERNAME" {
  default = "ubuntu" #here we are using user as ubuntu, because we have taken AMIs of ubuntu machine
}

#Now we will create security group for Bastion host. so we will give a variable for My IP
variable "MYIP" { # Here "MYIP" is a "variable" which will use security group ingress rules. 
  default = "183.83.39.124/32"
}

#Now we will use AmazonActiveMQ which is the replacement for RabbitMQ
#When we will create AmazonActiveMQ, we need to provide "user name & password" , these we will define as variables.

variable "rmquser" {
  default = "rabbit"
}

variable "rmqpass" {
  default = "rath@1111"
}

# Now we will create RDS. And we'll have database username and password, which we're also going to use to log to our RDS instance and provision it with our schemas. 
#So we need the database username and password & again we will put them as variables.i.e 

variable "dbuser" {
  default = "admin"
}

variable "dbpass" {
  default = "admin123"
}

variable "dbname" {
  default = "accounts" // here account is the database name for this project
}

variable "instance_count" {
  default = "1" //here this is the variable i.e used to lunch the instance. If we want to increase the instance, we will increase the number.
}

//Now we will create a VPC
variable "VPC_NAME" {
  default = "vprofile-VPC"
}

//We're going to create six subnets in three different zones, three public subnet and three private subnets.
variable "Zone1" {
  default = "us-east-2a"
}
variable "Zone2" {
  default = "us-east-2b"
}
variable "Zone3" {
  default = "us-east-2c"
}

//Now we will create "vpc CIDR"
variable "vpcCIDR" {
  default = "172.21.0.0/16"
}

//Now we will 3 publc subnet & 3 private Subnet
variable "PubSub1CIDR" { //public subnet
  default = "172.21.1.0/24"
}

variable "PubSub2CIDR" {
  default = "172.21.2.0/24"
}

variable "PubSub3CIDR" {
  default = "172.21.3.0/24"
}

variable "PrivSub1CIDR" { //private subnet
  default = "172.21.4.0/24"
}

variable "PrivSub2CIDR" {
  default = "172.21.5.0/24"
}

variable "PrivSub3CIDR" {
  default = "172.21.6.0/24"
}











