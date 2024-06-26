resource "aws_dynamodb_table" "viajes" {
  name           = "Viajes"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = var.tags.local
}

resource "aws_dynamodb_table" "viaje_destino" {
  name           = "ViajeDestino"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = var.tags.local
}

resource "aws_dynamodb_table" "viaje_origen" {
  name           = "ViajeOrigen"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = var.tags.local
}

resource "aws_iam_policy" "dynamodb_policy" {
  name        = "DynamoDBAccessForLambda"
  description = "Permite a la función Lambda acceder a DynamoDB"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:Scan",
          "dynamodb:Query",
          "dynamodb:UpdateItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ]
        Resource = [
          "arn:aws:dynamodb:${var.aws_region}:${data.aws_caller_identity.current.account_id}:table/Viajes",
          "arn:aws:dynamodb:${var.aws_region}:${data.aws_caller_identity.current.account_id}:table/ViajeDestino",
          "arn:aws:dynamodb:${var.aws_region}:${data.aws_caller_identity.current.account_id}:table/ViajeOrigen"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "dynamodb_policy_attachment" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.dynamodb_policy.arn
}