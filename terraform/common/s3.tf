resource "aws_s3_bucket" "aaa" {
  acceleration_status = "Enabled"
  bucket              = "${var.environment}-aaa"
  region              = var.region

  cors_rule {
    allowed_headers = [
      "*",
    ]
    allowed_methods = [
      "POST",
      "GET",
      "PUT",
      "DELETE",
      "HEAD",
    ]
    allowed_origins = [
      "*",
    ]
    expose_headers = [
      "ETag",
    ]
    max_age_seconds = 0
  }

  lifecycle_rule {
    enabled = true

    expiration {
      days = 30
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_notification" "upload-notifications" {
  bucket = aws_s3_bucket.aaa.bucket

  topic {
    events = [
      "s3:ObjectCreated:*",
    ]
    filter_prefix = "aaa-search/"
    topic_arn     = aws_sns_topic.start-aaa-search.arn
  }
  topic {
    events = [
      "s3:ObjectCreated:*",
    ]
    filter_prefix = "aaa-aaa/"
    filter_suffix = ".mkv"
    topic_arn     = aws_sns_topic.aaa-aaa.arn
  }

}