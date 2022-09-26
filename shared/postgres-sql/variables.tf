variable "project_id" {
  description = "your_project_id"
  default= "zcelero-tech-talk"
}

variable "region" {
  description = "The region to host the cluster in"
  default     = "europe-west1"
}

variable "zones" {
  description = "The region to host the cluster in"
  default     = ["europe-west1-d"]
}