resource "aws_cloudwatch_metric_alarm" "log-alarm" {
  alarm_name          = "${var.environment}-log-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  threshold           = 0
  alarm_description   = "Errors in the ${var.environment}"
  treat_missing_data  = "notBreaching"
  namespace           = "LogMetrics"
  statistic           = "Sum"
  datapoints_to_alarm = 1
  metric_name         = "${title(var.environment)}Errors"
  period              = 60
}

resource "aws_cloudwatch_log_metric_filter" "log-metric-filter" {
  log_group_name = "${var.environment}-name"
  name           = "SearchErrors"
  pattern        = "ERROR"
  metric_transformation {
    name      = "${title(var.environment)}Errors"
    namespace = "LogMetrics"
    value     = "1"
  }
}

resource "aws_sns_topic" "email-notifications" {
  name = "${var.environment}-email-notifications"
}

resource "aws_sns_topic_policy" "email-notifications-policy" {
  arn    = aws_sns_topic.email-notifications.arn
  policy = data.aws_iam_policy_document.email-notifications.json
}

data "aws_iam_policy_document" "email-notifications" {
  statement {
    actions = [
    "sns:Publish"]
    resources = [
    aws_sns_topic.email-notifications.arn]
    condition {
      test = "StringEquals"
      values = [
      data.aws_caller_identity.current.account_id]
      variable = "aws:SourceOwner"
    }
    effect = "Allow"
    principals {
      identifiers = [
      "*"]
      type = "AWS"
    }
    sid = "EmailPolicy"
  }
}