variable "iam_users" {
  description = "Usuarios IAM"
  type = map(set(string))
}

variable "iam_groups" {
  description = "Mapa de los grupos"
  type = map(string)
}
