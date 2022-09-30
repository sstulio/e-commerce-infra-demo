variable "app_name" {
    description = "Application name in ArgoCD"
}
variable "repository" {
    description = "Application repository URL"
}
variable "source_path" {
    description = "Manifest files folder path"
    default = "k8s"
}
variable "target_revision" {
    description = "Target repository branch"
  default = "main"
}

resource "kubernetes_namespace" "order_service_demo" {
  metadata {
    name = var.app_name
  }
}

resource "kubernetes_manifest" "application_argocd_order_service_demo" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind = "Application"
    metadata = {
      finalizers = [
        "resources-finalizer.argocd.argoproj.io",
      ]
      name = "${var.app_name}"
      namespace = "argocd"
    }
    spec = {
      destination = {
        namespace = "${var.app_name}"
        server = "https://kubernetes.default.svc"
      }
      project = "default"
      source = {
        path = "${var.source_path}"
        repoURL = "${var.repository}"
        targetRevision = "${var.target_revision}"
      }
      syncPolicy = {
        automated = {
          selfHeal = true
        }
      }
    }
  }

  depends_on = [
    kubernetes_namespace.order_service_demo
  ]
}
