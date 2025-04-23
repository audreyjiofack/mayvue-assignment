resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP and HTTPS"
  vpc_id      = data.aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.config.web_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.config.allowed_ips
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(var.config.tags, {
    Name = format("%s-%s-${var.config.web_sg}", var.config.tags["environment"], var.config.tags["project"])
  })
}

resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "Allow access from web servers"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    from_port       = var.config.db_port
    to_port         = var.config.db_port
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
    cidr_blocks     = var.config.db_allowed_cidr_blocks
  }

  egress {
    from_port   = var.config.db_port
    to_port     = var.config.db_port
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.main.cidr_block]
  }
  tags = merge(var.config.tags, {
    Name = format("%s-%s-${var.config.db_sg}", var.config.tags["environment"], var.config.tags["project"])
  })
}

resource "aws_db_subnet_group" "sql" {
  name       = "rds-subnet-group"
  subnet_ids = var.config.db_subnet_ids

  tags = merge(var.config.tags, {
    Name = "rds-subnet-group"
  })
}

# resource "aws_security_group" "db_sg" {
#   name        = format("%s-%s-${var.db_sg}", var.tags["environment"], var.tags["project"])
#   description = "Security group for DB server"
#   vpc_id      = var.vpc_id
#   tags = merge(var.tags, {
#     Name = format("%s-%s-${var.db_sg}", var.tags["environment"], var.tags["project"])
#   })
# }

# resource "aws_security_group_rule" "db_inbound" {
#   type              = "ingress"
#   from_port         = var.db_port
#   to_port           = var.db_port
#   protocol          = "tcp"
#   cidr_blocks       = var.db_allowed_cidr_blocks
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

# resource "aws_security_group" "web_sg" {
#   name        = format("%s-%s-${var.web_sg}", var.tags["environment"], var.tags["project"])
#   description = "Security group for Web server"
#   vpc_id      = var.vpc_id
#   tags = merge(var.tags, {
#     Name = format("%s-%s-${var.db_sg}", var.tags["environment"], var.tags["project"])
#   })
# }

# resource "aws_security_group_rule" "web_inbound" {
#   type              = "ingress"
#   from_port         = var.web_ports
#   to_port           = var.web_ports
#   protocol          = "tcp"
#   cidr_blocks       = var.allowed_ips
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



