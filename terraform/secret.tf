// secret.tf

resource "aws_secretsmanager_secret" "example_secret" {
  name = "example_secret_db_proxy"
}

resource "aws_secretsmanager_secret_version" "db_version" {
  secret_id = aws_secretsmanager_secret.example_secret.id
  secret_string = jsonencode({
    "username"             = aws_db_instance.example_rds.username
    "password"             = var.db.password
    "engine"               = "postgres"
    "host"                 = aws_db_instance.example_rds.address
    "port"                 = 5432
    "dbInstanceIdentifier" = aws_db_instance.example_rds.id
  })
}