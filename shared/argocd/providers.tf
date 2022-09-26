terraform {

  backend "gcs" {
    bucket = "zcelero-tech-talk-terraform-state"
    prefix = "shared/argocd"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.37.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.13.0"
    }
  }

  required_version = ">= 0.14"
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zones[0]
}

data "terraform_remote_state" "gke" {
  backend = "gcs"
  config = {
    bucket = "${var.project_id}-terraform-state"
    prefix = "shared/gke-cluster"
  }
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host     = "https://${data.terraform_remote_state.gke.outputs.endpoint}"
  token    = data.google_client_config.default.access_token
  cluster_ca_certificate = "${base64decode(data.terraform_remote_state.gke.outputs.cluster_ca_certificate)}"
}


provider "kubectl" {
  host                   = "https://${data.terraform_remote_state.gke.outputs.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.terraform_remote_state.gke.outputs.cluster_ca_certificate)
  load_config_file       = false
}
