# resource "aws_db_subnet_group" "sql" {
#   name       = "rds-subnet-group"
#   subnet_ids = var.config.db_subnet_ids

#   tags = merge(var.config.tags, {
#     Name = "rds-subnet-group"
#   })
# }
data "aws_iam_role" "rds_ad_role" {
  name = "rds-sql-ad-role"
}

resource "aws_db_instance" "sqlserver" {
  identifier        = var.config.identifier
  engine            = var.config.engine
  engine_version    = var.config.engine_version
  instance_class    = var.config.instance_class
  allocated_storage = var.config.allocated_storage
  # max_allocated_storage           = var.config.max_allocated_storage
  #db_name  = var.config.db_name
  username = data.aws_ssm_parameter.db_username.value
  password = data.aws_ssm_parameter.db_password.value

  multi_az = var.config.multi_az

  storage_encrypted = var.config.storage_encrypted

  port = var.config.db_port
  # domain               = var.config.ad_domain_id
  domain_iam_role_name = data.aws_iam_role.rds_ad_role.name

  db_subnet_group_name   = var.config.db_subnet_group_name
  vpc_security_group_ids = var.config.vpc_security_group_ids
  maintenance_window     = var.config.maintenance_window
  backup_window          = var.config.backup_window
  # enabled_cloudwatch_logs_exports = var.config.enabled_cloudwatch_logs_exports
  # create_cloudwatch_log_group     = var.config.create_cloudwatch_log_group

  backup_retention_period = var.config.backup_retention_period
  skip_final_snapshot     = var.config.skip_final_snapshot
  deletion_protection     = var.config.deletion_protection

  performance_insights_enabled          = var.config.performance_insights_enabled
  performance_insights_retention_period = var.config.performance_insights_retention_period
  # create_monitoring_role                = var.config.create_monitoring_role
  # monitoring_interval = var.config.monitoring_interval

  # options                   = var.config.options
  # create_db_parameter_group = var.config.create_db_parameter_group
  license_model      = var.config.license_model
  timezone           = var.config.timezone
  character_set_name = var.config.character_set_name

  tags = merge(var.config.tags, {
    Name = format("%s-%s-${var.config.db_name}", var.config.tags["environment"], var.config.tags["project"])
  })
  # create_db_parameter_group = var.config.create_db_parameter_group
  # major_engine_version      = var.config.major_engine_version
}

# resource "aws_db_instance" "db" {
#   identifier                 = format("%s-%s-${var.config.rds_identifier}", var.config.tags["environment"], var.config.tags["project"])
#   engine                     = var.config.rds_engine
#   engine_version             = var.config.rds_engine_version
#   instance_class             = var.config.db_instance_class
#   allocated_storage          = var.config.db_storage_size
#   storage_type               = var.config.db_storage_type
#   multi_az                   = var.config.multi_az
#   publicly_accessible        = var.config.publicly_accessible
#   db_subnet_group_name       = aws_db_subnet_group.rds_subnet_group.name
#   vpc_security_group_ids     = [var.config.rds_sg_id]
#   db_name                    = var.config.db_name
#   username                   = data.aws_ssm_parameter.db_username.value
#   password                   = data.aws_ssm_parameter.db_password.value
#   parameter_group_name       = aws_db_parameter_group.custom_mariadb_parameter_group.name
#   backup_retention_period    = var.config.backup_retention_period
#   backup_window              = var.config.backup_window
#   maintenance_window         = var.config.maintenance_window
#   auto_minor_version_upgrade = var.config.auto_minor_version_upgrade
#   skip_final_snapshot        = var.config.skip_final_snapshot
#   storage_encrypted          = var.config.storage_encrypted
#   tags = merge(var.config.tags, {
#     Name = format("%s-%s-${var.config.db_name}", var.config.tags["environment"], var.config.tags["project"])
#   })
#   # Disable deletion protection during destroy
#   deletion_protection = var.config.deletion_protection

#   # Create a final snapshot when skip_final_snapshot is false
#   final_snapshot_identifier = var.config.skip_final_snapshot == false ? format("%s-%s-snapshot-%s", var.config.rds_identifier, var.config.db_name, replace(timestamp(), ":", "-")) : null
# }
