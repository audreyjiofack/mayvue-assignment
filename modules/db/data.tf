data "aws_ssm_parameter" "db_password" {
  name            = "sqlDb-password"
  with_decryption = true
}

data "aws_ssm_parameter" "db_username" {
  name            = "sqlDb-username"
  with_decryption = true
}