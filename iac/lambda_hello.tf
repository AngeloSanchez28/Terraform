data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "development_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "archive_file" "hello" {
  type        = "zip"
  source_dir  = "../src/hello"
  output_path = "bin/hello.zip"
}

resource "aws_lambda_function" "lambda_main" {
  filename         = data.archive_file.hello.output_path
  function_name    = "Prueba"
  role             = aws_iam_role.iam_for_lambda.arn
  handler          = "main.handler"

  source_code_hash = data.archive_file.hello.output_base64sha256

  runtime          = "nodejs18.x"

  environment {
    variables = {
      "key" = "value"
    }
  }
}
