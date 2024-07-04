provider "aws" {
  region = "us-west-1"
  profile = var.aws_role[local.env_name]
  access_key  = var.aws_access_key
  secret_key  = var.aws_secret_key
  max_retries = 2

  default_tags {
    tags = var.tags[local.env_name]
  }
}

data "aws_caller_identity" "current" {}

