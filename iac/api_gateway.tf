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

resource "aws_api_gateway_rest_api" "api" {
  name        = "ViajesAPI"
  description = "API for viajes microservices"
}

# Resource and Method for publicarViaje1
resource "aws_api_gateway_resource" "publicarViaje1_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "publicar-viaje1"
}

resource "aws_api_gateway_method" "publicarViaje1_post_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.publicarViaje1_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "publicarViaje1_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.publicarViaje1_resource.id
  http_method             = aws_api_gateway_method.publicarViaje1_post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.publicarViaje1_lambda_arn}/invocations"
}

# Resource and Method for publicarViaje2
resource "aws_api_gateway_resource" "publicarViaje2_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "publicar-viaje2"
}

resource "aws_api_gateway_method" "publicarViaje2_post_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.publicarViaje2_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "publicarViaje2_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.publicarViaje2_resource.id
  http_method             = aws_api_gateway_method.publicarViaje2_post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.publicarViaje2_lambda_arn}/invocations"
}

# Resource and Method for buscarViaje
resource "aws_api_gateway_resource" "buscarViaje_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "buscar-viaje"
}

resource "aws_api_gateway_method" "buscarViaje_post_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.buscarViaje_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "buscarViaje_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.buscarViaje_resource.id
  http_method             = aws_api_gateway_method.buscarViaje_post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.buscarViaje_lambda_arn}/invocations"
}

# Deployment
resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    aws_api_gateway_integration.publicarViaje1_lambda_integration,
    aws_api_gateway_integration.publicarViaje2_lambda_integration,
    aws_api_gateway_integration.buscarViaje_lambda_integration
  ]
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "dev"
}

# Permissions
resource "aws_lambda_permission" "publicarViaje1_apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.publicarViaje1_lambda_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "publicarViaje2_apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.publicarViaje2_lambda_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "buscarViaje_apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.buscarViaje_lambda_arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}


