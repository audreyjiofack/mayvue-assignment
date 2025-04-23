# resource "aws_security_group" "db_sg" {
#   name        = format("%s-%s-${var.config.db_sg}", var.config.tags["environment"], var.config.tags["project"])
#   description = "Security group for DB server"
#   vpc_id      = var.config.vpc_id
#   tags = merge(var.config.tags, {
#     Name = format("%s-%s-${var.config.db_sg}", var.config.tags["environment"], var.config.tags["project"])
#   })
# }

# resource "aws_security_group_rule" "db_inbound" {
#   type              = "ingress"
#   from_port         = var.config.db_port
#   to_port           = var.config.db_port
#   protocol          = "tcp"
#   cidr_blocks       = var.config.db_allowed_cidr_blocks
#   security_group_id = aws_security_group.db_sg.id
# }

# resource "aws_security_group_rule" "allow_all_outbound" {
#   type              = "egress"
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.db_sg.id
# }