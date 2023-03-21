terraform {
  backend "s3" {
    bucket = "terra-vprofile-state121"
    key    = "terraform/backend"
    region = "us-east-2"
  }

}