terraform {
  backend "gcs" {
    bucket = "zcelero-tech-talk-terraform-state"
    prefix = "shared/postgres-sql"
  }
}

resource "google_sql_database_instance" "main" {
  name                = "zcelero-tech-talk-db"
  database_version    = "POSTGRES_9_6"
  region              = "europe-west1"
  deletion_protection = false

  settings {
    tier = "db-f1-micro"

    ip_configuration {
      ipv4_enabled = true

      //DEMO ONLY! It is a good pratice to restrict your db inboud connections
      authorized_networks {
        name  = "default"
        value = "0.0.0.0/0"
      }
    }
  }
}

output "name" {
  value = resource.google_sql_database_instance.main.name
}

output "public_ip_address" {
  value = resource.google_sql_database_instance.main.public_ip_address
}
