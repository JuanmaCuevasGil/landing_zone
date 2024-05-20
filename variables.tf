variable "estocolmo_cidr" {
  description = "CIDR Estocolmo"
  type        = string
}

/* variable "public_subnet" {
    description = "CIDR public subnet"
    type = string
}

variable "private_subnet" {
    description = "CIDR private subnet"
    type = string
} */

variable "subnets" {
  description = "Lista de subnets"
  type        = list(string)
}

variable "tags" {
  description = "value"
  type        = map(string)
}

variable "sg_ingress_cidr" {
  description = "CIDR for ingress traffic"
  type        = string
}

variable "ec2_specs" {
  description = "Parámetros de la instancia"
  type        = map(string)

}

variable "instancias" {
  description = "Nombre de las instancias"
  type        = set(string)
}

variable "enable_monitoring" {
  description = "Habilita el despliegue de un servidor de monitoreo"
  type        = number
}

variable "ingress_port_list" {
  description = "Lista de puertos de ingress"
  type = list(number)
}