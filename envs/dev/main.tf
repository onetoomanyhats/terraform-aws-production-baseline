provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}

module "network" {
  source               = "../../modules/network"
  name                 = var.name
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "security" {
  source = "../../modules/security"
  name   = var.name
  vpc_id = module.network.vpc_id
  app_port = var.app_port
}

module "alb" {
  source            = "../../modules/alb"
  name              = var.name
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  alb_sg_id         = module.security.alb_sg_id
  app_port          = var.app_port
}

module "app_asg" {
  source              = "../../modules/app_asg"
  name                = var.name
  private_subnet_ids  = module.network.private_subnet_ids
  app_sg_id           = module.security.app_sg_id
  target_group_arn    = module.alb.target_group_arn
  instance_type       = var.instance_type
  desired_capacity    = var.desired_capacity
  min_size            = var.min_size
  max_size            = var.max_size
  ami_id              = var.ami_id
  app_port            = var.app_port
}
