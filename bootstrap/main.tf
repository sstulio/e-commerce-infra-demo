resource "google_storage_bucket" "default" {
  name          = "zcelero-tech-talk-terraform-state"
  force_destroy = false
  location      = "europe-west1"
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}