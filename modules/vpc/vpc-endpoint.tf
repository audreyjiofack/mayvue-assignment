# resource "aws_vpc_endpoint" "ssm" {
#   vpc_id             = aws_vpc.main.id
#   service_name       = "com.amazonaws.us-east-1.ssm"
#   vpc_endpoint_type  = "Interface"
#   subnet_ids         = [aws_subnet.private.id]
#   security_group_ids = [aws_security_group.web_sg.id]
# }

# resource "aws_vpc_endpoint" "ssm_messages" {
#   vpc_id             = aws_vpc.main.id
#   service_name       = "com.amazonaws.us-east-1.ssmmessages"
#   vpc_endpoint_type  = "Interface"
#   subnet_ids         = [aws_subnet.private.id]
#   security_group_ids = [aws_security_group.web_sg.id]
# }

# resource "aws_vpc_endpoint" "ec2messages" {
#   vpc_id             = aws_vpc.main.id
#   service_name       = "com.amazonaws.us-east-1.ec2messages"
#   vpc_endpoint_type  = "Interface"
#   subnet_ids         = [aws_subnet.private.id]
#   security_group_ids = [aws_security_group.web_sg.id]
# }

# # aaS3 Gateway Endpoint
# resource "aws_vpc_endpoint" "s3" {
#   vpc_id            = aws_vpc.main.id
#   service_name      = "com.amazonaws.${var.aws_region}.s3"
#   route_table_ids   = concat([aws_route_table.public.id], aws_route_table.private[*].id)
#   vpc_endpoint_type = "Gateway"

#   tags = merge(var.tags, {
#     Name = format("%s-%s-s3-endpoint", var.tags["environment"], var.tags["project"])
#   })
# }

# # DynamoDB Gateway Endpoint
# resource "aws_vpc_endpoint" "dynamodb" {
#   vpc_id            = aws_vpc.main.id
#   service_name      = "com.amazonaws.${var.aws_region}.dynamodb"
#   route_table_ids   = concat([aws_route_table.public.id], aws_route_table.private[*].id)
#   vpc_endpoint_type = "Gateway"

#   tags = merge(var.tags, {
#     Name = format("%s-%s-dynamodb-endpoint", var.tags["environment"], var.tags["project"])
#   })
# }
