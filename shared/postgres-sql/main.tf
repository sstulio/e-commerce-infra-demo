resource "google_sql_database_instance" "main" {
  name = "zcelero-tech-talk-db"
  database_version = "POSTGRES_9_6"
  region       = "${var.region}"
  deletion_protection = false

  settings {
    tier = "db-f1-micro"

    ip_configuration {
        ipv4_enabled    = true

        //DEMO ONLY! It is a good pratice to restrict your db inboud connections
        authorized_networks {
          name = "default"
          value = "0.0.0.0/0"
        }
      }
  }
}