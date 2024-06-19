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
