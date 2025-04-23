locals {
  env = merge(
    yamldecode(file("${path.module}/../../environments/region.yaml")),
    yamldecode(file("${path.module}/../../environments/dev.yaml"))
  )
}

terraform {
  required_version = ">= 1.10.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket  = "dev-mayvue-tf-state"
    key     = "ec2/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    # dynamodb_table = "dev-mayvue-tf-state-lock"
  }
}

provider "aws" {
  region = local.env.region
}

module "ec2" {
  for_each = local.env.configs
  source   = "../../modules/ec2/"
  configs  = each.value
  providers = {
    aws = aws
  }
}