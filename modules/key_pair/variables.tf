variable "keys" {
  description = "Valores para configurar nuestra generación de keys"
  type = object({
    algorithm = string 
    rsa_bits = number
    key_name = map(string)
  })
}