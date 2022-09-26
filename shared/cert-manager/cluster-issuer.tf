data "kubectl_file_documents" "letsencrypt_issuer" {
    content = file("../manifests/cert-manager/cluster-issuer-production.yaml")
}

resource "kubectl_manifest" "letsencrypt_issuer" {
    count     = length(data.kubectl_file_documents.letsencrypt_issuer.documents)
    yaml_body = element(data.kubectl_file_documents.letsencrypt_issuer.documents, count.index)
    override_namespace = "cert-manager"

    depends_on = [
      module.cert_manager,
    ]
}