output "key_pair_pem" {
  description = "Map of the keys to enter instances by ssh"
  value = tls_private_key.tls_key_pair
}
