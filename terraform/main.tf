provider "aws" {
}

terraform {
  backend "s3" {
    region  = "us-west-1"
    encrypt = true
  }
}

data "aws_caller_identity" "current" {}