data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "./modules/vpc"

  project     = var.project
  environment = var.environment
  vpc_cidr    = var.vpc_cidr

  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  availability_zones = slice(
    data.aws_availability_zones.available.names,
    0,
    3
  )
}

module "eks" {
  source = "./modules/eks"

  project            = var.project
  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
}

module "rds" {
  source = "./modules/rds"

  project               = var.project
  environment           = var.environment
  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  db_password           = var.db_password
  eks_security_group_id = module.eks.eks_security_group_id
}
