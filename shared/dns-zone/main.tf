resource "google_dns_managed_zone" "dns_zone" {
  name        = "tuliodesouza-dns-zone"
  dns_name    = "tuliodesouza.com."
  description = "Domain DNS zone"
}

resource "google_dns_record_set" "argocd" {
  name = "argocd.techtalk.${google_dns_managed_zone.dns_zone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.dns_zone.name

  rrdatas = ["${data.terraform_remote_state.nginx_ingress.outputs.public_ip_address}"]

  depends_on = [
    google_dns_managed_zone.dns_zone
  ]
}

resource "google_dns_record_set" "order_service_demo" {
  name = "order-service-demo.techtalk.${google_dns_managed_zone.dns_zone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.dns_zone.name

  rrdatas = ["${data.terraform_remote_state.nginx_ingress.outputs.public_ip_address}"]

  depends_on = [
    google_dns_managed_zone.dns_zone
  ]
}

resource "google_dns_record_set" "users_service_demo" {
  name = "users-service-demo.techtalk.${google_dns_managed_zone.dns_zone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.dns_zone.name

  rrdatas = ["${data.terraform_remote_state.nginx_ingress.outputs.public_ip_address}"]

  depends_on = [
    google_dns_managed_zone.dns_zone
  ]
}

resource "google_dns_record_set" "root_domain" {
  name = "${google_dns_managed_zone.dns_zone.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.dns_zone.name

  rrdatas = ["${data.terraform_remote_state.nginx_ingress.outputs.public_ip_address}"]

  depends_on = [
    google_dns_managed_zone.dns_zone
  ]
}