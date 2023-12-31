terraform {
  required_version = ">1.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.1"
    }
  }

  backend "s3" {
    bucket         = "rsinfotech-terraform-statefile"
    key            = "terraform-statefile"
    region         = "ap-south-1"
    role_arn       = "arn:aws:iam::640111764884:role/stsassume-role"
    dynamodb_table = "rsinfotech-terraform-statetable"
  }
}

provider "aws" {
  region = "ap-south-1"
  assume_role {
    role_arn     = "arn:aws:iam::640111764884:role/stsassume-role"
    session_name = "terraform-sts"
  }
}
