# Output para el ARN del rol IAM utilizado por las funciones Lambda
output "aws_iam_role_arn" {
  value       = aws_iam_role.iam_for_lambda.arn
  description = "ARN of the IAM role used by the Lambda functions"
}

# Outputs para las funciones Lambda
output "lambda_buscarViaje_arn" {
  value       = aws_lambda_function.buscarviaje.arn
  description = "ARN of the buscarViaje Lambda function"
}

output "lambda_publicarViaje1_arn" {
  value       = aws_lambda_function.publicarviaje1.arn
  description = "ARN of the publicarViaje1 Lambda function"
}

output "lambda_publicarViaje2_arn" {
  value       = aws_lambda_function.publicarviaje2.arn
  description = "ARN of the publicarViaje2 Lambda function"
}

# Output para la URL del API Gateway
output "api_gateway_url" {
  value = "https://${aws_api_gateway_rest_api.myapi.execution_arn}/dev"
  description = "URL of the deployed API Gateway"
}

#Outputs Tablas

output "dynamodb_table_viajes_arn" {
  value       = aws_dynamodb_table.viajes.arn
  description = "ARN for DynamoDB table 'Viajes'"
}

output "dynamodb_table_viaje_destino_arn" {
  value       = aws_dynamodb_table.viaje_destino.arn
  description = "ARN for DynamoDB table 'ViajeDestino'"
}

output "dynamodb_table_viaje_origen_arn" {
  value       = aws_dynamodb_table.viaje_origen.arn
  description = "ARN for DynamoDB table 'ViajeOrigen'"
}
