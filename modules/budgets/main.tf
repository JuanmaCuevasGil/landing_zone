#Creates a number of budgets dinamically with attributes written on tfvars
resource "aws_budgets_budget" "zero_spend_budget" {
  for_each          = { for budget in var.budgets : budget.budget_name => budget }
  name              = each.value.budget_name
  budget_type       = "COST"
  time_unit         = "MONTHLY"
  limit_amount      = each.value.budget_limit_amount
  limit_unit        = "USD"

  cost_types {
    include_tax                = true
    include_subscription       = true
    use_blended                = false
    include_refund             = false
    include_credit             = false
    include_upfront            = true
    include_recurring          = true
    include_other_subscription = true
    include_support            = true
    include_discount           = true
    use_amortized              = false
  }

  time_period_start = each.value.budget_time_period_start
  time_period_end   = each.value.budget_time_period_end

  dynamic "notification" {
    for_each = each.value.budget_notifications
    content {
      comparison_operator           = notification.value.comparison_operator
      notification_type             = notification.value.notification_type
      threshold                     = notification.value.threshold
      threshold_type                = notification.value.threshold_type
      subscriber_email_addresses    = notification.value.budget_subscriber_email_addresses
      subscriber_sns_topic_arns     = []
    }
  }
}