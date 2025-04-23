variable "config" {
  type = object({
    aws_region           = string
    availability_zones   = list(string)
    cidr_block           = string
    enable_dns_support   = bool
    tags                 = map(string)
    enable_dns_hostnames = bool
    nat_gateway_count    = number
    public_subnets       = string
    private_subnets      = string
  })
}
