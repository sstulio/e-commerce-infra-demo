terraform {
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
  project = "zcelero-tech-talk"
  region  = "europe-west1"
  zone    = "europe-west1-d"
}

# Kubernetes Provider
provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
