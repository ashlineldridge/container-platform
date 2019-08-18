resource "google_container_cluster" "cluster" {
  provider = "google-beta"

  name     = var.cluster_name
  location = var.region

  # We use separately managed node pool(s) as per the recommendation
  # (https://www.terraform.io/docs/providers/google/r/container_cluster.html). To allow
  # this we create the smallest possible node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count = 1

  # Disable basic auth
  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  addons_config {
    istio_config {
      disabled = false
      auth = "AUTH_MUTUAL_TLS"
    }
  }
}

resource "google_container_node_pool" "general_purpose_node_pool" {
  name       = "${var.cluster_name}-general-purpose-node-pool"
  location   = var.region
  cluster    = google_container_cluster.cluster.name

  management {
    auto_repair = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = var.general_purpose_min_node_count
    max_node_count = var.general_purpose_max_node_count
  }
  initial_node_count = var.general_purpose_min_node_count

  node_config {
    machine_type = var.general_purpose_machine_type

    metadata = {
      disable-legacy-endpoints = "true"
    }

    # Needed for correctly functioning cluster, see
    # https://www.terraform.io/docs/providers/google/r/container_cluster.html#oauth_scopes
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only"
    ]
  }
}

