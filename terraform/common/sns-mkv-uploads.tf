resource "aws_sns_topic" "mkv-uploads" {
  name = "${var.environment}-mkv-uploads"
}

resource "aws_sns_topic_policy" "mkv-uploads-policy" {
  arn    = aws_sns_topic.mkv-uploads.arn
  policy = data.aws_iam_policy_document.mkv-uploads.json
}

data "aws_iam_policy_document" "mkv-uploads" {
  statement {
    actions = [
    "sns:Publish"]
    resources = [
    aws_sns_topic.mkv-uploads.arn]
    condition {
      test = "ArnEquals"
      values = [
      aws_s3_bucket.uploads.arn]
      variable = "aws:SourceArn"
    }
    effect = "Allow"
    principals {
      identifiers = [
      "*"]
      type = "AWS"
    }
    sid = "UploadTopicPolicy2"
  }
}

resource "aws_sns_topic_subscription" "mkv_uploads-to-sqs" {
  endpoint  = aws_sqs_queue.mkv-uploads.arn
  protocol  = "sqs"
  topic_arn = aws_sns_topic.mkv-uploads.arn
}