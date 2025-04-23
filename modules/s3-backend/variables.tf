variable "config" {
  type = object({
    aws_region_main   = string
    aws_region_backup = string
    tags              = map(any)
    force_destroy     = bool
  })
  description = "Configuration map for s3 bucket"
}

