output "key_pair_pem_public" {
  value = tls_private_key.public_key_pair.private_key_pem
}

output "key_pair_pem_private" {
  value = tls_private_key.private_key_pair.private_key_pem
}
