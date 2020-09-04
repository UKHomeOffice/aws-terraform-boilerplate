// Dead letter queues

resource "aws_sqs_queue" "DLQ-aaaa-search-ready" {
  name                      = "${var.environment}-DLQ-aaaa-search-ready"
  message_retention_seconds = 120960
}

// Lambda triggers for the dead letter queues

resource "aws_lambda_event_source_mapping" "dlqsih-to-sqs-dlqif" {
  batch_size       = 1
  event_source_arn = aws_sqs_queue.DLQ-index-frames.arn
  function_name    = aws_lambda_function.DLQ-search-aaas-handler.function_name
}