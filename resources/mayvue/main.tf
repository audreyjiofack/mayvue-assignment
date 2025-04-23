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
    key     = "blue-green/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    # dynamodb_table = "dev-mayvue-tf-state-lock"
  }
}

provider "aws" {
  region = local.env.region.dev
}

#EC2 Instance SSM Access
resource "aws_iam_role" "ssm" {
  name = "ec2_ssm_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
  #permissions boundary if enforced
  #permissions_boundary = "arn:aws:iam::123456789012:policy/YourBoundaryPolicy"
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ssm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "ec2_ssm_instance_profile"
  role = aws_iam_role.ssm.name
}

module "blue_app" {
  source            = "../modules/ec2"
  name              = "dotnet-blue"
  environment       = "blue"
  app_package_url   = var.app_package_url
  sql_endpoint      = module.sql_server.endpoint
  db_name           = module.sql_server.db_name
  subnet_id         = data.aws_subnet.private_a.id
  security_group_id = var.config.security_group_id
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  key_name          = var.key_name
  instance_profile  = aws_iam_instance_profile.ssm_profile.name
  user_data_script  = file("../../scripts/install_iis.ps1")
}

module "green_app" {
  source            = "../modules/ec2"
  name              = "dotnet-green"
  environment       = "green"
  app_package_url   = var.app_package_url
  sql_endpoint      = module.sql_server.endpoint
  db_name           = module.sql_server.db_name
  subnet_id         = data.aws_subnet.private_b.id
  security_group_id = var.config.security_group_id
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  key_name          = var.key_name
  instance_profile  = aws_iam_instance_profile.ssm_profile.name
  user_data_script  = file("../../scripts/install_iis.ps1")
}

resource "aws_cloudwatch_metric_alarm" "blue_high_cpu" {
  alarm_name          = "HighCPU-BlueApp"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "70"
  alarm_description   = "This metric monitors high CPU usage"
  alarm_actions       = [var.config.alarm_sns_topic_arn]
  dimensions = {
    InstanceId = module.blue_app.instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "green_high_cpu" {
  alarm_name          = "HighCPU-GreenApp"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "70"
  alarm_description   = "This metric monitors high CPU usage"
  alarm_actions       = [var.config.alarm_sns_topic_arn]
  dimensions = {
    InstanceId = module.green_app.instance_id
  }
}

#Route53 Weighted Records for Blue-Green
resource "aws_route53_record" "blue" {
  zone_id        = var.config.route53_zone_id
  name           = var.config.app_dns_name
  type           = "CNAME"
  ttl            = 60
  set_identifier = "blue"
  weighted_routing_policy {
    weight = 100
  }
  records = [module.blue_app.public_dns]
}

resource "aws_route53_record" "green" {
  zone_id        = var.config.route53_zone_id
  name           = var.config.app_dns_name
  type           = "CNAME"
  ttl            = 60
  set_identifier = "green"

  weighted_routing_policy {
    weight = 0
  }
  records = [module.green_app.public_dns]
}

#Outputs
output "blue_app_dns" {
  value = module.blue_app.public_dns
}

output "green_app_dns" {
  value = module.green_app.public_dns
}

output "db_endpoint" {
  value = module.sql_server.endpoint
}

output "app_dns" {
  value = var.config.app_dns_name
}