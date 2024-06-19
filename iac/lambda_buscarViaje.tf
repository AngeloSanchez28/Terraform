data "aws_iam_policy_document" "assume_role_buscarViaje" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda_buscarViaje" {
  name = "development_lambda_buscarViaje"
  assume_role_policy = data.aws_iam_policy_document.assume_role_buscarViaje.json
}

data "archive_file" "buscarViaje" {
  type        = "zip"
  source_dir  = "../src/buscarViaje"
  output_path = "bin/buscarViaje.zip"
}

resource "aws_lambda_function" "buscarViaje_lambda" {
  filename         = data.archive_file.buscarViaje.output_path
  function_name    = "BuscarViajeFunction"
  role             = aws_iam_role.iam_for_lambda_buscarViaje.arn
  handler          = "main.handler"
  source_code_hash = data.archive_file.buscarViaje.output_base64sha256
  runtime          = "nodejs18.x"

  environment {
    variables = {
      "key1" = "value"
    }
  }
}
