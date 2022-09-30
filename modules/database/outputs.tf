output "host" {
  value = data.terraform_remote_state.database.outputs.public_ip_address
  sensitive = true
}

output "password" {
  value = random_uuid.dbpassword.result
  sensitive = true
}