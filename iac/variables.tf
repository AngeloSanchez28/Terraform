variable "tags" {}
variable "aws_role" {
  description = "AWS Roles"
  type = map(string)
}

locals{
  env_name = lower(terraform.workspace)  
}

variable "aws_region" {
  description = "The AWS region to deploy in"
  type        = string
  default     = "us-west-1"
}
