resource "tls_private_key" "virginia_key_pair" {
  algorithm = var.algorithm_key_pair
  rsa_bits  = var.rsa_bits_key_pair
}

resource "aws_key_pair" "my_key_pair" {
  key_name   = var.key_name_private
  public_key = tls_private_key.virginia_key_pair.public_key_openssh
}