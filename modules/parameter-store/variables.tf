variable "config" {
  type = object({
    db_name = map(object({
      username = string
      password = string
    }))
    aws_region = string
    tags       = map(any)
  })
  description = "Configuration map for parameter store"
}
