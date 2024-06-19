output "publicarViaje1_lambda_arn" {
  value = var.publicarViaje1_lambda_arn
}

output "publicarViaje2_lambda_arn" {
  value = var.publicarViaje2_lambda_arn
}

output "buscarViaje_lambda_arn" {
  value = var.buscarViaje_lambda_arn
}

output "api_invoke_url" {
  value = aws_api_gateway_deployment.deployment.invoke_url
}

