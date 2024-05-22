variable "name" {
  description = "Nombre del presupuesto"
  type        = string
}

variable "limit_amount" {
  description = "Cantidad límite del presupuesto"
  type        = string
}

variable "time_period_start" {
  description = "Fecha de inicio del período del presupuesto"
  type        = string
}

variable "time_period_end" {
  description = "Fecha de finalización del período del presupuesto"
  type        = string
}

variable "subscriber_email_addresses" {
  description = "Direcciones de correo electrónico de los suscriptores del presupuesto"
  type        = list(string)
}
