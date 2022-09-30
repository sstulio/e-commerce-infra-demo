terraform {
  backend "gcs" {
    bucket = "zcelero-tech-talk-terraform-state"
    prefix = "apps/order-service-demo"
  }
}

locals {
  app_name   = "order-service-demo"
  repository = "https://github.com/sstulio/order-service-demo"
}

module "argocd_application" {
  source     = "../../modules/argocd-app"
  app_name   = local.app_name
  repository = local.repository
}

module "database" {
  source    = "../../modules/database"
  db_name   = "${local.app_name}-db"
  user_name = "${local.app_name}-user"
}

resource "kubernetes_secret" "secret" {
  metadata {
    name      = "${local.app_name}-secrets"
    namespace = local.app_name
  }

  data = {
    DATABASE_DNS = <<EOT
      host=${module.database.host}
      dbname=${local.app_name}-db
      user=${local.app_name}-user
      password=${module.database.password} 
      port=5432 
      sslmode=disable
      EOT
  }
}

