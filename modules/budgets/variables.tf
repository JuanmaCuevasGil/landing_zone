variable "name" {
  description = "Budget name"
  type        = string
}

variable "limit_amount" {
  description = "Budget limit amount"
  type        = string
}

variable "time_period_start" {
  description = "Budget period start date"
  type        = string
}

variable "time_period_end" {
  description = "Budget period end date"
  type        = string
}

variable "subscriber_email_addresses" {
  description = "Budget subscribers' email addresses"
  type        = list(string)
}
