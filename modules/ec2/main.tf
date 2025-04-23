resource "aws_instance" "web" {
  for_each                = var.configs
  ami                     = each.value.ec2_instance_ami
  instance_type           = each.value.ec2_instance_type
  key_name                = each.value.ec2_instance_key_name
  iam_instance_profile    = aws_iam_instance_profile.ssm_profile.name
  vpc_security_group_ids  = [each.value.security_group_id]
  disable_api_termination = each.value.enable_termination_protection
  user_data               = file("../../scripts/install_iis.ps1")

  subnet_id = each.value.create_on_public_subnet ? each.value.public_subnet : each.value.private_subnets[0]

  root_block_device {
    volume_size = each.value.root_volume_size
  }

  tags = merge(each.value.tags, {
    Name = format("%s-%s-${each.value.instance_name}", each.value.tags["environment"], each.value.tags["project"])
  })
}


