data "archive_file" "function" {
  type        = "zip"
  source_file = "./src/index.py"
  output_path = "lambda/function.zip"
}

resource "null_resource" "pip" {
  provisioner "local-exec" {
    command = "rm -rf ./lib && pip install -r requirements.txt -t ./lib/python"
  }
}

data "archive_file" "layer" {
  depends_on  = ["null_resource.pip"]
  type        = "zip"
  source_dir  = "./lib"
  output_path = "lambda/lib.zip"
}

resource "aws_lambda_layer_version" "layer" {
  filename         = "${data.archive_file.layer.output_path}"
  layer_name       = "lib"
  source_code_hash = "${data.archive_file.layer.output_base64sha256}"

  compatible_runtimes = ["python3.6"]
}

resource "aws_lambda_function" "example_lambda" {
  function_name = "example_lambda"

  runtime          = "python3.6"
  handler          = "index.lambda_handler"
  filename         = "${data.archive_file.function.output_path}"
  role             = "${aws_iam_role.iam_role.arn}"
  source_code_hash = "${data.archive_file.function.output_base64sha256}"
  layers           = ["${aws_lambda_layer_version.layer.arn}"]
}
