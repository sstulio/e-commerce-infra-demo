terraform {
  backend "gcs" {
    bucket = "zcelero-tech-talk-terraform-state"
    prefix  = "apps/order-service-demo"
  }
}

resource "kubernetes_namespace" "order_service_demo" {
  metadata {
    name = "order-service-demo"
  }
}

data "terraform_remote_state" "database" {
  backend = "gcs"
  config = {
    bucket = "${var.project_id}-terraform-state"
    prefix = "shared/postgres-sql"
  }
}

data "kubectl_file_documents" "argocd_app" {
  content = file("../manifests/order-service-demo.yaml")
}

resource "kubectl_manifest" "argocd_app" {
  count     = length(data.kubectl_file_documents.argocd_app.documents)
  yaml_body = element(data.kubectl_file_documents.argocd_app.documents, count.index)

  depends_on = [
    kubernetes_namespace.order_service_demo,
  ]
}

resource "google_sql_database" "database" {
  name     = "order-service-demo-db"
  instance = data.terraform_remote_state.database.outputs.name
}

resource "random_uuid" "dbpassword" {
}

resource "google_sql_user" "users" {
  name     = "order-service-demo-user"
  instance = data.terraform_remote_state.database.outputs.name
  password = random_uuid.dbpassword.result
}

locals {
  public_ip_addres = data.terraform_remote_state.database.outputs.public_ip_address
  db_name          = google_sql_database.database.name
  user             = "order-service-demo-user"
  password         = random_uuid.dbpassword.result
}

resource "kubernetes_secret" "secret" {
  metadata {
    name      = "order-service-demo-secrets"
    namespace = "order-service-demo"
  }

  data = {
    DATABASE_DNS = "host=${local.public_ip_addres} user=${local.user} password=${local.password} dbname=${local.db_name} port=5432 sslmode=disable"
  }
}
