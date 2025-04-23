output "db_sec_grp_id" {
  description = "ID of the created sec grp"
  value       = aws_security_group.db_sg.id
}