# API Gateway
resource "aws_api_gateway_rest_api" "myapi" {
  name        = "MyAPI"
  description = "My API Gateway"
} 
#Recurso
resource "aws_api_gateway_resource" "myresource" {
  rest_api_id = aws_api_gateway_rest_api.myapi.id
  parent_id   = aws_api_gateway_rest_api.myapi.root_resource_id
  path_part   = "test"
}
#Metodo
resource "aws_api_gateway_method" "mymethod" {
  rest_api_id   = aws_api_gateway_rest_api.myapi.id
  resource_id   = aws_api_gateway_resource.myresource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.myapi.id
  resource_id = aws_api_gateway_resource.myresource.id
  http_method = aws_api_gateway_method.mymethod.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.lambda_main.invoke_arn
}

resource "aws_lambda_permission" "apigw" {
  statement_id = "AllowAPIGatewayInvoke"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_main.function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.myapi.execution_arn}/*/*"
}

###GPT###

# Recursos API Gateway para cada función Lambda
resource "aws_api_gateway_resource" "resource_buscarviaje" {
  rest_api_id = aws_api_gateway_rest_api.myapi.id
  parent_id   = aws_api_gateway_rest_api.myapi.root_resource_id
  path_part   = "buscar-viaje"
}

resource "aws_api_gateway_resource" "resource_publicarviaje1" {
  rest_api_id = aws_api_gateway_rest_api.myapi.id
  parent_id   = aws_api_gateway_rest_api.myapi.root_resource_id
  path_part   = "publicar-viaje"
}

resource "aws_api_gateway_resource" "resource_publicarviaje2" {
  rest_api_id = aws_api_gateway_rest_api.myapi.id
  parent_id   = aws_api_gateway_rest_api.myapi.root_resource_id
  path_part   = "publicar-viaje2"
}

# Métodos API Gateway para cada función Lambda
resource "aws_api_gateway_method" "post_buscarviaje" {
  rest_api_id   = aws_api_gateway_rest_api.myapi.id
  resource_id   = aws_api_gateway_resource.resource_buscarviaje.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "post_publicarviaje1" {
  rest_api_id   = aws_api_gateway_rest_api.myapi.id
  resource_id   = aws_api_gateway_resource.resource_publicarviaje1.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "post_publicarviaje2" {
  rest_api_id   = aws_api_gateway_rest_api.myapi.id
  resource_id   = aws_api_gateway_resource.resource_publicarviaje2.id
  http_method   = "POST"
  authorization = "NONE"
}

# Integraciones API Gateway con Lambda
resource "aws_api_gateway_integration" "lambda_integration_buscarviaje" {
  rest_api_id              = aws_api_gateway_rest_api.myapi.id
  resource_id              = aws_api_gateway_resource.resource_buscarviaje.id
  http_method              = "POST"
  integration_http_method  = "POST"
  type                     = "AWS_PROXY"
  uri                      = aws_lambda_function.buscarviaje.invoke_arn
}

resource "aws_api_gateway_integration" "lambda_integration_publicarviaje1" {
  rest_api_id              = aws_api_gateway_rest_api.myapi.id
  resource_id              = aws_api_gateway_resource.resource_publicarviaje1.id
  http_method              = "POST"
  integration_http_method  = "POST"
  type                     = "AWS_PROXY"
  uri                      = aws_lambda_function.publicarviaje1.invoke_arn
}

resource "aws_api_gateway_integration" "lambda_integration_publicarviaje2" {
  rest_api_id              = aws_api_gateway_rest_api.myapi.id
  resource_id              = aws_api_gateway_resource.resource_publicarviaje2.id
  http_method              = "POST"
  integration_http_method  = "POST"
  type                     = "AWS_PROXY"
  uri                      = aws_lambda_function.publicarviaje2.invoke_arn
}

# Permiso de Lambda para API Gateway (uno para cada función Lambda)
resource "aws_lambda_permission" "apigw_buscarviaje" {
  statement_id  = "AllowAPIGatewayInvokeBuscarViaje"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.buscarviaje.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.myapi.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw_publicarviaje1" {
  statement_id  = "AllowAPIGatewayInvokePublicarViaje1"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.publicarviaje1.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.myapi.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw_publicarviaje2" {
  statement_id  = "AllowAPIGatewayInvokePublicarViaje2"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.publicarviaje2.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.myapi.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "mydeployment" {
  depends_on  = [aws_api_gateway_integration.lambda_integration,
    aws_api_gateway_integration.lambda_integration_buscarviaje,
    aws_api_gateway_integration.lambda_integration_publicarviaje1,
    aws_api_gateway_integration.lambda_integration_publicarviaje2]
  rest_api_id = aws_api_gateway_rest_api.myapi.id
  stage_name  = "dev"
}

resource "aws_api_gateway_stage" "stage" {
  stage_name    = "test"
  rest_api_id   = aws_api_gateway_rest_api.myapi.id
  deployment_id = aws_api_gateway_deployment.mydeployment.id
  description   = "Development stage"
  variables = {
    key = "value"
  }
}