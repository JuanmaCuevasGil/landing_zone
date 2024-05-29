# Creates an AWS budget for monitoring costs with a $0.01 spending threshold. Notifications are sent via email to the specified address.
resource "aws_budgets_budget" "zero_spend_budget" {
  name              = var.name
  budget_type       = "COST"
  time_unit         = "MONTHLY"
  limit_amount      = var.limit_amount
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
  time_period_start = var.time_period_start
  time_period_end   = var.time_period_end
 
  notification {
    comparison_operator = "GREATER_THAN"
    notification_type   = "ACTUAL"
    threshold           = 10
    threshold_type      = "PERCENTAGE"
    subscriber_email_addresses = var.subscriber_email_addresses
    subscriber_sns_topic_arns  = []
  }

    notification {
    comparison_operator = "GREATER_THAN"
    notification_type   = "ACTUAL"
    threshold           = "0.01"
    threshold_type      = "ABSOLUTE_VALUE"
    subscriber_email_addresses = var.subscriber_email_addresses
    subscriber_sns_topic_arns  = []
  }
}