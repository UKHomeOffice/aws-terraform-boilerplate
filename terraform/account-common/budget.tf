resource "aws_budgets_budget" "budget" {
  budget_type = "COST"
  limit_amount = "300"
  limit_unit = "USD"
  time_period_start = "2019-01-01_00:00"
  time_unit = "MONTHLY"
  name = "Quota"
  notification {
    comparison_operator = "GREATER_THAN"
    notification_type = "ACTUAL"
    threshold = 100
    threshold_type = "PERCENTAGE"
    subscriber_email_addresses = []
  }
}