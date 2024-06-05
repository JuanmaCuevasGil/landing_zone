# Define a TLS private key for each key pair
resource "tls_private_key" "tls_key_pair" {
for_each = var.keys.key_name
algorithm = var.keys.algorithm
rsa_bits = var.keys.rsa_bits
}

# Define an AWS key pair for each key
resource "aws_key_pair" "key_pair" {
  for_each = var.keys.key_name
  key_name   = each.value
  public_key = tls_private_key.tls_key_pair[each.key].public_key_openssh
}

#Creates a local file with each key in terraform
resource "local_file" "publickey" {
  for_each = var.keys.key_name
  content  = tls_private_key.tls_key_pair[each.key].private_key_pem
  filename = "./keys/${each.value}.pem"
}
