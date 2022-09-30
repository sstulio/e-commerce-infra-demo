locals {
  host = "argocd.techtalk.tuliodesouza.com"
}

resource "kubernetes_manifest" "ingress_argocd_argocd_server_ingress" {
  manifest = {
    apiVersion = "networking.k8s.io/v1"
    kind       = "Ingress"
    metadata = {
      annotations = {
        "cert-manager.io/cluster-issuer"               = "letsencrypt-production"
        "kubernetes.io/ingress.class"                  = "nginx"
        "kubernetes.io/tls-acme"                       = "true"
        "nginx.ingress.kubernetes.io/backend-protocol" = "HTTPS"
        "nginx.ingress.kubernetes.io/ssl-passthrough"  = "true"
      }
      name      = "argocd-server-ingress"
      namespace = "argocd"
    }
    spec = {
      rules = [
        {
          host = "${local.host}"
          http = {
            paths = [
              {
                backend = {
                  service = {
                    name = "argocd-server"
                    port = {
                      name = "https"
                    }
                  }
                }
                path     = "/"
                pathType = "Prefix"
              },
            ]
          }
        },
      ]
      tls = [
        {
          hosts = [
            "${local.host}",
          ]
          secretName = "argocd-secret"
        },
      ]
    }
  }
}
