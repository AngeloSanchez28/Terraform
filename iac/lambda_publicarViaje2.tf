data "aws_iam_policy_document" "assume_role_publicarviaje2" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "archive_file" "publicarviaje2" {
  type        = "zip"
  source_dir  = "../src/publicarViaje2"
  output_path = "bin/publicarViaje2.zip"
}

resource "aws_lambda_function" "publicarviaje2" {
  filename         = data.archive_file.publicarviaje2.output_path
  function_name    = "publicarViaje2"
  role             = aws_iam_role.iam_for_lambda.arn # Reutilizando el rol IAM
  handler          = "main.handler"

  source_code_hash = data.archive_file.publicarviaje2.output_base64sha256

  runtime          = "nodejs18.x"

  environment {
    variables = {
      VIAJES_TABLE       = "Viajes",
      VIAJE_DESTINO_TABLE = "ViajeDestino",
      VIAJE_ORIGEN_TABLE  = "ViajeOrigen",
      "key" = "value"
    }
  }
}
