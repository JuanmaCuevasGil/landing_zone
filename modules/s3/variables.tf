variable "bucket_name" {
  description = "Nombre del bucket"
  type = string
}

resource "aws_budgets_budget" "zero_spend_budget" {
  name              = "ZeroSpendBudget"
  budget_type       = "COST"
  time_unit         = "MONTHLY"
  limit_amount      = "0.01"
  limit_unit        = "USD"
  cost_types {
    include_tax           = true
    include_subscription  = true
    use_blended           = false
    include_refund        = false
    include_credit        = false
    include_upfront       = true
    include_recurring     = true
    include_other_subscription = true
    include_support       = true
    include_discount      = true
    use_amortized         = false
  }
  time_period_start = "2023-01-01_00:00"
  time_period_end   = "2087-01-01_00:00"
 
  notification {
    comparison_operator = "GREATER_THAN"
    notification_type   = "ACTUAL"
    threshold           = 0.01
    threshold_type      = "ABSOLUTE_VALUE"
    subscriber_email_addresses = ["juanma@yopmail.com"] 
    subscriber_sns_topic_arns  = []
  }
}