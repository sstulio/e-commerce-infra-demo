resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

data "kubectl_file_documents" "argocd" {
    content = file("../manifests/argocd/install.yaml")
}

data "kubectl_file_documents" "argocd_ingress" {
    content = file("../manifests/argocd/ingress.yaml")
}

resource "kubectl_manifest" "argocd" {
    count     = length(data.kubectl_file_documents.argocd.documents)
    yaml_body = element(data.kubectl_file_documents.argocd.documents, count.index)
    override_namespace = "argocd"

    depends_on = [
      kubernetes_namespace.argocd,
    ]
}

resource "kubectl_manifest" "argocd_ingress" {
    count     = length(data.kubectl_file_documents.argocd_ingress.documents)
    yaml_body = element(data.kubectl_file_documents.argocd_ingress.documents, count.index)
    override_namespace = "argocd"

    depends_on = [
      kubectl_manifest.argocd,
    ]
}