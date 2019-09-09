variable "region" {
  type = string
  description = "Default GCP region"
}

variable "production_mode" {
  type = bool
  description = "Whether to enable production features such as high-availability"
}

variable "cluster_vpc_cidr" {
  type = string
  description = "CIDR block for the cluster VPC"
}

variable "cluster_public_subnet_a_cidr" {
  type = string
  description = "CIDR block for the public cluster subnet in AZA"
}

variable "cluster_public_subnet_b_cidr" {
  type = string
  description = "CIDR block for the public cluster subnet in AZB"
}

variable "cluster_public_subnet_c_cidr" {
  type = string
  description = "CIDR block for the public cluster subnet in AZC"
}

variable "cluster_private_subnet_a_cidr" {
  type = string
  description = "CIDR block for the private cluster subnet in AZA"
}

variable "cluster_private_subnet_b_cidr" {
  type = string
  description = "CIDR block for the private cluster subnet in AZB"
}

variable "cluster_private_subnet_c_cidr" {
  type = string
  description = "CIDR block for the private cluster subnet in AZC"
}

variable "cluster_name" {
  type = string
  description = "Name of the EKS cluster"
}

variable "cluster_vpc_id" {
  type = string
  description = "ID of the VPC in which to provision EKS worker nodes"
}

variable "cluster_subnet_ids" {
  type = list(string)
  description = "IDs of the subnets in which to provision EKS worker nodes"
}
