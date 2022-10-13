terraform {
  backend "gcs" {
    bucket = "zcelero-tech-talk-terraform-state"
    prefix = "shared/cert-manager"
  }
}

data "kubectl_file_documents" "clusterissuer_file" {
  content = file("cluster-issuer.yaml")
}

resource "kubectl_manifest" "clusterissuer_letsencrypt_production" {
  count              = length(data.kubectl_file_documents.clusterissuer_file.documents)
  yaml_body          = element(data.kubectl_file_documents.clusterissuer_file.documents, count.index)
  override_namespace = "cert-manager"

  depends_on = [
    module.cert_manager
  ]
}

module "cert_manager" {
  source         = "terraform-iaac/cert-manager/kubernetes"
  namespace_name = "cert-manager"

  cluster_issuer_email                   = "admin@techtalk.tuliodesouza.com"
  cluster_issuer_name                    = "cert-manager-global"
  cluster_issuer_private_key_secret_name = "cert-manager-private-key"
}
