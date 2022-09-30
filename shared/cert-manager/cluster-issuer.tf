locals {
  name = "letsencrypt-production"
}

resource "kubernetes_manifest" "clusterissuer_letsencrypt_production" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind = "ClusterIssuer"
    metadata = {
      name = "${locals.name}"
    }
    spec = {
      acme = {
        email = "tulio@techtalk.tuliodesouza.com"
        privateKeySecretRef = {
          name = "${locals.name}"
        }
        server = "https://acme-v02.api.letsencrypt.org/directory"
        solvers = [
          {
            http01 = {
              ingress = {
                class = "nginx"
              }
            }
          },
        ]
      }
    }
  }
}