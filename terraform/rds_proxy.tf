// rds_proxy.tf

resource "aws_db_proxy" "example_rds_proxy" {
  name                   = "example-rds-proxy"
  engine_family          = "POSTGRESQL"
  role_arn               = aws_iam_role.example_rds_proxy.arn
  vpc_security_group_ids = [aws_security_group.example_rds_proxy.id]
  vpc_subnet_ids         = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]

  auth {
    auth_scheme = "SECRETS"
    iam_auth    = "DISABLED"
    secret_arn  = aws_secretsmanager_secret.example_secret.arn
  }
}

resource "aws_db_proxy_default_target_group" "example_rds_proxy" {
  db_proxy_name = aws_db_proxy.example_rds_proxy.name
}

resource "aws_db_proxy_target" "example" {
  db_instance_identifier = aws_db_instance.example_rds.identifier
  db_proxy_name          = aws_db_proxy.example_rds_proxy.name
  target_group_name      = aws_db_proxy_default_target_group.example_rds_proxy.name
}

output "example_rds_proxy" {
  value = aws_db_proxy.example_rds_proxy.endpoint
}
