data "archive_file" "lambda" {
  type        = "zip"
  output_path = "lambda.zip"
  source_file = "./src/index.py"
}

resource "aws_lambda_function" "example_lambda" {
  function_name = "example_lambda"

  runtime          = "python3.6"
  handler          = "index.lambda_handler"
  filename         = "${data.archive_file.lambda.output_path}"
  role             = "${aws_iam_role.iam_role.arn}"
  source_code_hash = "${data.archive_file.lambda.output_base64sha256}"
}
