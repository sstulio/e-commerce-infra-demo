variable "db_name" {
  description = "Database name"
}

variable "user_name" {
  description = "Database name"
}

data "terraform_remote_state" "database" {
  backend = "gcs"
  config = {
    bucket = "zcelero-tech-talk-terraform-state"
    prefix = "shared/postgres-sql"
  }
}

resource "google_sql_database" "database" {
  name     = var.db_name
  instance = data.terraform_remote_state.database.outputs.name

  depends_on = [
    google_sql_user.user
  ]
}

resource "random_uuid" "dbpassword" {}

resource "google_sql_user" "user" {
  name     = var.user_name
  instance = data.terraform_remote_state.database.outputs.name
  password = random_uuid.dbpassword.result
}