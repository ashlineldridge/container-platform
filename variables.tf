variable "cluster_name" {
  type = string
  description = "Name of the EKS cluster (e.g., 'development' or 'production')"
}

variable "region" {
  type = string
  description = "AWS region to provision resources in"
}

variable "production_mode" {
  type = bool
  description = "Whether to enable production features such as high-availability"
}

variable "vpc_cidr" {
  type = string
  description = "CIDR block for the cluster VPC"
}

variable "public_subnet_a_cidr" {
  type = string
  description = "CIDR block for the public cluster subnet in AZA"
}

variable "public_subnet_b_cidr" {
  type = string
  description = "CIDR block for the public cluster subnet in AZB"
}

variable "public_subnet_c_cidr" {
  type = string
  description = "CIDR block for the public cluster subnet in AZC"
}

variable "private_subnet_a_cidr" {
  type = string
  description = "CIDR block for the private cluster subnet in AZA"
}

variable "private_subnet_b_cidr" {
  type = string
  description = "CIDR block for the private cluster subnet in AZB"
}

variable "private_subnet_c_cidr" {
  type = string
  description = "CIDR block for the private cluster subnet in AZC"
}
