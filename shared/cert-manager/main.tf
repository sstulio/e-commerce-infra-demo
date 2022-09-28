terraform {
  backend "gcs" {
    bucket = "zcelero-tech-talk-terraform-state"
    prefix = "shared/cert-manager"
  }
}

module "cert_manager" {
  source         = "terraform-iaac/cert-manager/kubernetes"
  namespace_name = "cert-manager"

  cluster_issuer_email                   = "admin@techtalk.tuliodesouza.com"
  cluster_issuer_name                    = "cert-manager-global"
  cluster_issuer_private_key_secret_name = "cert-manager-private-key"
}
