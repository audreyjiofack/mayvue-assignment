variable "config" {
  type = object({
    aws_region             = string
    identifier             = string
    engine                 = string
    engine_version         = string
    instance_class         = string
    allocated_storage      = number
    db_name                = string
    username               = string
    multi_az               = bool
    storage_encrypted      = bool
    db_subnet_ids          = list(string)
    db_port                = number
    db_subnet_group_name   = string
    vpc_security_group_ids = list(string)
    maintenance_window     = string
    backup_window          = string
    # enabled_cloudwatch_logs_exports       = list(string)
    backup_retention_period               = number
    skip_final_snapshot                   = bool
    deletion_protection                   = bool
    performance_insights_enabled          = bool
    performance_insights_retention_period = number
    # monitoring_interval                   = number
    license_model      = string
    timezone           = string
    character_set_name = string
    tags               = map(string)
  })
  description = "Configuration for RDS SQL Server instance"
}

