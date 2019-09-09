variable "project_id" {
  type = "string"
  description = "GCP project ID"
}

variable "project_name" {
  type = "string"
  description = "GCP project name"
}

variable "region" {
  type = "string"
  description = "Default GCP region"
}

variable "cluster_name" {
  type = "string"
  description = "Name of the GKE cluster"
}

variable "general_purpose_machine_type" {
  type = "string"
  description = "Machine type to use for the general-purpose node pool"
}

variable "general_purpose_min_node_count" {
  type = "string"
  description = "The minimum number of nodes PER ZONE in the general-purpose node pool"
}

variable "general_purpose_max_node_count" {
  type = "string"
  description = "The maximum number of nodes PER ZONE in the general-purpose node pool"
}
