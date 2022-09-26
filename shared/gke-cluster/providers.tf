terraform {
  
  backend "gcs" {
    bucket = "zcelero-tech-talk-terraform-state"
    prefix  = "shared/gke-cluster"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.37.0"
    }
  }

  required_version = ">= 0.14"
}

provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zones[0]
}

