data "aws_iam_policy_document" "assume_role_publicarViaje1" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda_publicarViaje1" {
  name = "development_lambda_publicarViaje1"
  assume_role_policy = data.aws_iam_policy_document.assume_role_publicarViaje1.json
}

data "archive_file" "publicarViaje1" {
  type        = "zip"
  source_dir  = "../src/publicarViaje1"
  output_path = "bin/publicarViaje1.zip"
}

resource "aws_lambda_function" "publicarViaje1_lambda" {
  filename         = data.archive_file.publicarViaje1.output_path
  function_name    = "PublicarViaje1Function"
  role             = aws_iam_role.iam_for_lambda_publicarViaje1.arn
  handler          = "main.handler"
  source_code_hash = data.archive_file.publicarViaje1.output_base64sha256
  runtime          = "nodejs18.x"

  environment {
    variables = {
      "key1" = "value"
    }
  }
}

