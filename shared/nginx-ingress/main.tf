# Deploy resources on GKE
resource "kubernetes_namespace" "nginx_ingress" {
  metadata {
    name = "nginx-ingress"
  }
}

resource "google_compute_address" "ingress_ip_address" {
  name = "nginx-controller"
}

module "nginx-controller" {
  source  = "terraform-iaac/nginx-controller/helm"

  ip_address = google_compute_address.ingress_ip_address.address
  namespace = "nginx-ingress"

  depends_on = [
    kubernetes_namespace.nginx_ingress
  ]
}

output "public_ip_address" {
  value = google_compute_address.ingress_ip_address.address
}
