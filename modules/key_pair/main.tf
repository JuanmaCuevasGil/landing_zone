# Define a TLS private key for the Virginia key pair
resource "tls_private_key" "public_key_pair" {
  algorithm = var.algorithm_key_pair
  rsa_bits  = var.rsa_bits_key_pair
}

resource "tls_private_key" "private_key_pair" {
  algorithm = var.algorithm_key_pair
  rsa_bits  = var.rsa_bits_key_pair
}

# Define an AWS key pair using the Virginia private key
resource "aws_key_pair" "my_private_key_pair" {
  key_name   = var.key_name_private
  public_key = tls_private_key.private_key_pair.public_key_openssh
}

resource "aws_key_pair" "my_public_key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.public_key_pair.public_key_openssh
}