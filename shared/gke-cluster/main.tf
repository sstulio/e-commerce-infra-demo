terraform {
  backend "gcs" {
    bucket = "zcelero-tech-talk-terraform-state"
    prefix = "shared/gke-cluster"
  }
}

locals {
  service_account = "terraform@zcelero-tech-talk.iam.gserviceaccount.com"
}

module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  project_id                 = var.project_id
  name                       = "${var.project_id}-gke"
  region                     = var.region
  zones                      = var.zones
  network                    = module.gcp-network.network_name
  subnetwork                 = module.gcp-network.subnets_names[0]
  ip_range_pods              = var.ip_range_pods_name
  ip_range_services          = var.ip_range_services_name
  http_load_balancing        = false
  network_policy             = false
  horizontal_pod_autoscaling = true
  filestore_csi_driver       = false
  regional                   = false

  node_pools = [
    {
      name               = "${var.project_id}-node-pool"
      machine_type       = "e2-medium"
      node_locations     = "${var.zones[0]}"
      min_count          = 1
      max_count          = 1
      local_ssd_count    = 0
      spot               = false
      disk_size_gb       = 50
      disk_type          = "pd-standard"
      image_type         = "COS_CONTAINERD"
      enable_gcfs        = false
      enable_gvnic       = false
      auto_repair        = true
      auto_upgrade       = true
      service_account    = local.service_account
      preemptible        = true
      initial_node_count = 1
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "${var.project_id}-node-pool"
    }
  }

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "${var.project_id}-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "${var.project_id}-node-pool",
    ]
  }
}
