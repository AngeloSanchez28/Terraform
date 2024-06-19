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

variable "publicarViaje1_lambda_arn" {
  description = "ARN for PublicarViaje1 Lambda function"
  type        = string
}

variable "publicarViaje2_lambda_arn" {
  description = "ARN for PublicarViaje2 Lambda function"
  type        = string
}

variable "buscarViaje_lambda_arn" {
  description = "ARN for BuscarViaje Lambda function"
  type        = string
}

variable "aws_region" {
  description = "The AWS region to deploy in"
  type        = string
  default     = "us-west-1"
}

