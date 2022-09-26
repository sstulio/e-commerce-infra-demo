output "name" {
  value = "${resource.google_sql_database_instance.main.name}"
}

output "public_ip_address" {
  value = "${resource.google_sql_database_instance.main.public_ip_address}"
}