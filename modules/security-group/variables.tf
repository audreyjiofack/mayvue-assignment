variable "config" {
  type = object({
    aws_region             = string
    tags                   = map(any)
    db_port                = number
    web_ports              = map(number)
    db_allowed_cidr_blocks = list(string)
    allowed_ips            = list(string)
    db_sg                  = string
    db_subnet_ids          = list(string)
    web_sg                 = string
    # vpc_id                 = string
  })
}