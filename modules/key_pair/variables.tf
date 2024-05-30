variable "algorithm_key_pair" {
  description = "Algorithm with which the key is encrypted"
  type = string
  sensitive = true
}

variable "rsa_bits_key_pair" {
  description = "Key length"
  type = number
}

variable "key_name_private" {
  description = "Name Key Pair"
  type = string
}

variable "key_name" {
  description = "Name Key Pair Public"
  type = string
}