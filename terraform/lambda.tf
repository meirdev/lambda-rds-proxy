resource "aws_lambda_function" "example_lambda" {
  filename      = data.archive_file.example_lambda.output_path
  function_name = "example_lambda"
  role          = aws_iam_role.example_lambda.arn
  handler       = "example_lambda.handler"
  runtime       = "python3.10"
  timeout       = 10

  vpc_config {
    subnet_ids         = [aws_subnet.public_subnet.id]
    security_group_ids = [aws_security_group.example_lambda.id]
  }

  environment {
    variables = {
      RDS_ENDPOINT       = aws_db_instance.example_rds.address
      RDS_PROXY_ENDPOINT = aws_db_proxy.example_rds_proxy.endpoint
      DB_USERNAME        = var.db.username
      DB_PASSWORD        = var.db.password
    }
  }
}

data "archive_file" "example_lambda" {
  type        = "zip"
  source_dir  = "${path.module}/../lambda/"
  output_path = "${path.module}/../lambda_files.zip"
}

resource "aws_lambda_function_url" "example_lambda" {
  function_name      = aws_lambda_function.example_lambda.function_name
  authorization_type = "NONE"

  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}

output "example_lambda" {
  value = aws_lambda_function_url.example_lambda.function_url
}
