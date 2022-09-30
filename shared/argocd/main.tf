terraform {
  backend "gcs" {
    bucket = "zcelero-tech-talk-terraform-state"
    prefix = "shared/argocd"
  }
}

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

data "kubectl_file_documents" "argocd" {
  content = file("../manifests/argocd/install.yaml")
}

resource "kubectl_manifest" "argocd" {
  count              = length(data.kubectl_file_documents.argocd.documents)
  yaml_body          = element(data.kubectl_file_documents.argocd.documents, count.index)
  override_namespace = "argocd"

  depends_on = [
    kubernetes_namespace.argocd,
  ]
}

