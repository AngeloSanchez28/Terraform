data "aws_iam_policy_document" "assume_role_publicarviaje1" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "archive_file" "publicarviaje1" {
  type        = "zip"
  source_dir  = "../src/publicarViaje1"
  output_path = "bin/publicarViaje1.zip"
}

resource "aws_lambda_function" "publicarviaje1" {
  filename         = data.archive_file.publicarviaje1.output_path
  function_name    = "publicarViaje1"
  role             = aws_iam_role.iam_for_lambda.arn # Reutilizando el rol IAM
  handler          = "main.handler"

  source_code_hash = data.archive_file.publicarviaje1.output_base64sha256

  runtime          = "nodejs18.x"

  environment {
    variables = {
      "key" = "value"
    }
  }
}
