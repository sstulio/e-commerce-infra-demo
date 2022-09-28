terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.37.0"
    }
  }

  required_version = ">= 0.14"
}

provider "google" {
  project = "zcelero-tech-talk"
  region  = "europe-west1"
  zone    = "europe-west1-d"
}

