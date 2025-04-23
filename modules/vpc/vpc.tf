resource "aws_vpc" "main" {
  cidr_block           = var.config.cidr_block
  enable_dns_support   = var.config.enable_dns_support
  enable_dns_hostnames = var.config.enable_dns_hostnames

  tags = {
    Name = "iis_vpc"
  }
}