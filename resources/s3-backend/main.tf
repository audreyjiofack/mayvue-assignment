
locals {
  env = merge(
    yamldecode(file("${path.module}/../../environments/region.yaml")).region.alias,
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
}

module "s3-backend" {
  source = "../../modules/s3-backend"
  config = local.env.s3
}
