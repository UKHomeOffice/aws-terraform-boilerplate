
resource "aws_cloudwatch_dashboard" "chunks-log-dashboard" {
  dashboard_name = "${var.environment}-chunks-log"
  dashboard_body = templatefile("../common/dashboards/cloudwatch-metrics-chunks-log.json", {
    environment = local.environment
    region = local.region
  })
}