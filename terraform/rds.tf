// rds.tf

resource "aws_db_instance" "example_rds" {
  engine                 = "postgres"
  engine_version         = "11.20"
  allocated_storage      = 5
  instance_class         = "db.t3.micro"
  username               = var.db.username
  password               = var.db.password
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.example_rds.id]
  db_subnet_group_name   = aws_db_subnet_group.example_rds.name
}

resource "aws_db_subnet_group" "example_rds" {
  name       = "example_rds"
  subnet_ids = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
}

output "example_rds" {
  value = aws_db_instance.example_rds.endpoint
}
