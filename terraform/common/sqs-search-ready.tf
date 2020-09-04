resource "aws_sqs_queue" "aaaa-search-ready" {
  content_based_deduplication = false
  delay_seconds               = 0
  fifo_queue                  = false
  message_retention_seconds   = 86400
  name                        = "${var.environment}-aaaa-search-ready"
  receive_wait_time_seconds   = 0
  redrive_policy              = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.DLQ-aaaa-search-ready.arn}\",\"maxReceiveCount\":10}"
  visibility_timeout_seconds  = 60
}

resource "aws_sqs_queue_policy" "aaaa-search-ready-policy" {
  queue_url = aws_sqs_queue.aaaa-search-ready.id
  policy    = data.aws_iam_policy_document.aaaa-search-ready.json
}

data "aws_iam_policy_document" "aaaa-search-ready" {
  statement {
    actions = [
    "sqs:SendMessage"]
    resources = [
    "*"]
    condition {
      test = "ArnEquals"
      values = [
      aws_sqs_queue.aaaa-search-ready.arn,
      aws_sns_topic.aaaa-search-ready.arn]
      variable = "aws:SourceArn"
    }
    effect = "Allow"
    principals {
      identifiers = [
      "*"]
      type = "AWS"
    }
    sid = "AllowSNSToSend"
  }
}
