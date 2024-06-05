variable "cidr_map" {
  description = "Map of CIDR blocks for VPC, subnets, etc."
  type        = map(string)
}

variable "ports" {
  description = "Ports & Protocols"
  type = map(object({
    ingress = map(object({
      from_port = number
      to_port   = number
      protocol  = string
    }))
    egress = object({
      from_port = number
      to_port   = number
      protocol  = string
    })
  }))
  
}


variable "vpc_ids" {
  description = "ID VPC Virginia"
  type        = map(string)
}

variable "private_ip" {
  description = "Private IP of jumpserver"
  type        = string
}
