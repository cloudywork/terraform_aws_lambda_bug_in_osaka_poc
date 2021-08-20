data "archive_file" "lambda_code_zip" {
  type        = "zip"
  source_dir  = "code"
  output_path = "zip/hw.zip"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "hello_world" {
  provider         = "aws.ap-northeast-3"
  depends_on       = ["data.archive_file.lambda_code_zip"]
  description      = "Hello World"
  filename         = "${data.archive_file.lambda_code_zip.output_path}"
  runtime          = "python3.7"
  timeout          = 30
  memory_size      = 128
  publish          = true
  role             = aws_iam_role.iam_for_lambda.arn
  function_name    = "hello_world"
  handler          = "hello_world.handler"
  source_code_hash = "${data.archive_file.lambda_code_zip.output_base64sha256}"
}
