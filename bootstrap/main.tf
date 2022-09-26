resource "google_storage_bucket" "default" {
  name          = "${var.project_id}-terraform-state"
  force_destroy = false
  location      = var.region
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}