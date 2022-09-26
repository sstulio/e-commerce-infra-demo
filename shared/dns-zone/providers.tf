terraform {
  
  backend "gcs" {
    bucket = "zcelero-tech-talk-terraform-state"
    prefix  = "shared/dns-zone"
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

data "terraform_remote_state" "nginx_ingress" {
  backend = "gcs"
  config = {
    bucket = "${var.project_id}-terraform-state"
    prefix = "shared/nginx-ingress"
  }
}
