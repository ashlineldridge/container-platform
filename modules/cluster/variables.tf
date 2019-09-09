variable "cluster_name" {
  type = string
}

variable "cluster_vpc_id" {
  type = string
}

variable "cluster_subnet_ids" {
  type = list(string)
}
