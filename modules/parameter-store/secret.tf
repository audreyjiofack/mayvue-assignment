resource "aws_ssm_parameter" "db_username" {
  for_each    = var.config.db_name
  name        = "${each.key}-username"
  description = "${each.key} username"
  type        = "SecureString"
  value       = each.value.username
  lifecycle {
    ignore_changes = [value]
  }
  tags = merge(
    var.config.tags,
    {
      Name = "${each.key}-username"
    }
  )
}

resource "aws_ssm_parameter" "db_password" {
  for_each    = var.config.db_name
  name        = "${each.key}-password"
  description = "${each.key} password"
  type        = "SecureString"
  value       = each.value.password
  lifecycle {
    ignore_changes = [value]
  }
  tags = merge(
    var.config.tags,
    {
      Name = "${each.key}-password"
    }
  )
}
