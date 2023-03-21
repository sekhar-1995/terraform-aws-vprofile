module "vpc" {
  source          = "terraform-aws-modules/vpc/aws" // here we are saying t download terraform-aws-modules form "vpc" "aws" section
 
name            = var.VPC_NAME                    // we are taking the values of "name & cidr" from vars.tf file
cidr            = var.VpcCIDR
azs             = [var.Zone1, var.Zone2, var.Zone3]
  private_subnets = [var.PrivSub1CIDR, var.PrivSub2CIDR, var.PrivSub3CIDR]
  public_subnets  = [var.PubSub1CIDR, var.PubSub2CIDR, var.PubSub3CIDR]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Terraform   = "true"
    Environment = "Prod"
  }
  vpc_tags = {
    Name = var.VPC_NAME
  }
}

