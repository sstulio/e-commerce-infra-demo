output "endpoint" {
  value = "${module.gke.endpoint}"
  sensitive = true
}

output "name" {
  value = "${module.gke.name}"
}

output "cluster_ca_certificate" {
  value = "${module.gke.ca_certificate}"
  sensitive = true
}