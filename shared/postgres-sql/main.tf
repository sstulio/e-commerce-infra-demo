resource "google_sql_database_instance" "main" {
  name = "zcelero-tech-talk-db"
  database_version = "POSTGRES_9_6"
  region       = "${var.region}"
  deletion_protection = false

  settings {
    tier = "db-f1-micro"
  }
}