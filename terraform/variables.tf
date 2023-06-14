// variables.tf

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "db" {
  type = map(any)
  default = {
    username = "your-username"
    password = "your-password"
  }
}
