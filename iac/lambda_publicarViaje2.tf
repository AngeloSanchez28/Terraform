
data "aws_iam_policy_document" "assume_role_publicarViaje2" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda_publicarViaje2" {
  name = "development_lambda_publicarViaje2"
  assume_role_policy = data.aws_iam_policy_document.assume_role_publicarViaje2.json
}

data "archive_file" "publicarViaje2" {
  type        = "zip"
  source_dir  = "../src/publicarViaje2"
  output_path = "bin/publicarViaje2.zip"
}

resource "aws_lambda_function" "publicarViaje2_lambda" {
  filename         = data.archive_file.publicarViaje2.output_path
  function_name    = "PublicarViaje2Function"
  role             = aws_iam_role.iam_for_lambda_publicarViaje2.arn
  handler          = "main.handler"
  source_code_hash = data.archive_file.publicarViaje2.output_base64sha256
  runtime          = "nodejs18.x"

  environment {
    variables = {
      "key1" = "value"
    }
  }
}

