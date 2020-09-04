// Lambdas and their triggers

resource "aws_lambda_function" "ffmpeg-chunker" {
  description                    = "Lambda to chunk up and format files"
  function_name                  = "${var.environment}-ffmpeg-chunker"
  handler                        = "index.handler"
  memory_size                    = 3008
  reserved_concurrent_executions = 50
  role                           = aws_iam_role.lambda-role.arn
  runtime                        = "nodejs12.x"
  timeout                        = 900
  filename                       = "../empty.zip"

  environment {
    variables = {
      "DYNAMO_TTL_DAYS"      = "30"
      "ENVIRONMENT"          = var.environment
      "LAMBDA_SETUP"         = "true"
      "aaa_PARTS_DB_TABLE" = aws_dynamodb_table.aaa-parts.name
    }
  }
}

resource "aws_lambda_event_source_mapping" "ffmpeg-chunker-to-sqs-svis" {
  batch_size       = 1
  event_source_arn = aws_sqs_queue.ffmpeg-aaa-chunker.arn
  function_name    = aws_lambda_function.ffmpeg-aaa-chunker.function_name
}

resource "aws_lambda_layer_version" "ffmpeg_layer" {
  s3_bucket           = var.s3-config-bucket
  s3_key              = "ffmpeg-lambda-layer.zip"
  layer_name          = "ffmpeg-static"
  compatible_runtimes = ["nodejs12.x", "python3.6", "python3.7", "java8"]
}

resource "aws_lambda_permission" "aaa-converter-permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.aaa-converter.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.componentApi.execution_arn}/*/*/*"
}
