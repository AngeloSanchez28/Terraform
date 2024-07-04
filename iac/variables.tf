variable "tags" {}
variable "aws_role" {
  description = "AWS Roles"
  type = map(string)
}

locals{
  env_name = lower(terraform.workspace)  
}

variable "aws_access_key" {
  description = "AWS access key"
}

variable "aws_secret_key" {
  description = "AWS secret key"
}

variable "aws_region" {
  description = "The AWS region to deploy in"
  type        = string
  default     = "us-west-1"
}
