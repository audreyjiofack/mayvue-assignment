variable "configs" {
  type = object({
    aws_region                    = string
    ec2_instance_ami              = string
    create_on_public_subnet       = bool
    ec2_instance_type             = string
    root_volume_size              = number
    instance_name                 = string
    ec2_instance_key_name         = string
    enable_termination_protection = bool
    security_group_id             = string
    web_ports                     = list(number)
    allowed_ips                   = map(string)
    tags                          = map(any)
    vpc_id                        = string
    private_subnets               = list(string)
    public_subnet                 = string
    # db_allowed_cidr_blocks        = list(string)
  })
  description = "Configuration map for EC2 instance and associated resources"
}
variable "aws_region" {
  description = "The AWS region where the resources will be created."
  type        = string
  default     = "us-east-1"
}