module "network" {
  source = "./modules/network"
  name_prefix = "${var.cluster_name}-cluster"
  production_mode = var.production_mode
  region = var.region
  vpc_cidr = var.vpc_cidr
  public_subnet_a_cidr = var.public_subnet_a_cidr
  public_subnet_b_cidr = var.public_subnet_b_cidr
  public_subnet_c_cidr = var.public_subnet_c_cidr
  private_subnet_a_cidr = var.private_subnet_a_cidr
  private_subnet_b_cidr = var.private_subnet_b_cidr
  private_subnet_c_cidr = var.private_subnet_c_cidr
}

module "cluster" {
  source = "./modules/cluster"
  cluster_name = var.cluster_name
  cluster_subnet_ids = module.network.subnet_ids
  cluster_vpc_id = module.network.vpc_id
}
