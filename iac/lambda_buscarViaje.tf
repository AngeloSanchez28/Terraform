data "aws_iam_policy_document" "assume_role_buscarviaje" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "archive_file" "buscarviaje" {
  type        = "zip"
  source_dir  = "../src/buscarViaje"
  output_path = "bin/buscarViaje.zip"
}

resource "aws_lambda_function" "buscarviaje" {
  filename         = data.archive_file.buscarviaje.output_path
  function_name    = "buscarViaje"
  role             = aws_iam_role.iam_for_lambda.arn # Reutilizando el rol IAM
  handler          = "main.handler"

  source_code_hash = data.archive_file.buscarviaje.output_base64sha256

  runtime          = "nodejs18.x"

  environment {
    variables = {
      "key" = "value"
    }
  }
}
