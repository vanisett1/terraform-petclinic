# # Lookup the Route 53 hosted zone for agklya.com
# data "aws_route53_zone" "selected" {
#   name         = "agklya.com"
#   private_zone = false
# }

module "vpc" {
  source               = "../../modules/vpc"
  cidr_block           = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  secure_subnet_cidrs  = ["10.0.5.0/24", "10.0.6.0/24"]
  azs                  = ["us-east-1a", "us-east-1b"]
  name                 = "dev-pet-clinic"
}

module "load_balancer" {
  source            = "../../modules/alb"
  name              = "dev-pet-clinic-lb"
  vpc_id            = module.vpc.vpc_id
  public_subnets    = module.vpc.public_subnets
  security_group_id = module.load_balancer.security_group_id # Now output from the ALB module
  target_group_name = "dev-pet-clinic-target-group"
  # certificate_arn   = module.acm.certificate_arn
}

module "autoscaling_group" {
  source               = "../../modules/asg"
  name                 = "dev-pet-clinic-asg"
  ami_id               = "ami-06f1103b8906b89a1" # Replace with your AMI ID
  instance_type        = "t2.micro"
  key_name             = "kube-demo"
  private_subnets      = module.vpc.private_subnets
  security_group_id    = module.autoscaling_group.security_group_id # Output from ASG module
  target_group_arn     = module.load_balancer.target_group_arn
  iam_instance_profile = module.autoscaling_group.iam_instance_profile # Output from ASG module
  ecr_registry         = "310655363801.dkr.ecr.us-east-1.amazonaws.com"
  ecr_repository       = "spring-petclinic-app"
  region               = "us-east-1"
  vpc_id               = module.vpc.vpc_id
  db_host              = module.rds.rds_cluster_endpoint
  db_password          = var.db_password

}


module "rds" {
  source                = "../../modules/rds"
  private_subnets       = module.vpc.private_subnets
  vpc_id                = module.vpc.vpc_id
  ec2_security_group_id = module.autoscaling_group.security_group_id # Now output from the ASG module
  database_name         = "petclinicdb"
  master_username       = "petadmin"
  master_password       = var.db_password
}

# Cloudflare DNS for petclinic subdomain
module "cloudflare" {
  source             = "../../modules/cloudflare"
  cloudflare_api_token = var.cloudflare_api_token
  domain_name        = "agklya.com"
  subdomain_name     = "petclinic-dev"
  load_balancer_dns_name = module.load_balancer.load_balancer_dns_name
}

# module "route53" {
#   source       = "../../modules/route53"
#   zone_id      = data.aws_route53_zone.selected.zone_id
#   subdomain    = "petclinic-dev.agklya.com"
#   alb_dns_name = module.load_balancer.alb_dns_name
#   alb_zone_id  = module.load_balancer.alb_zone_id
# }

# module "acm" {
#   source      = "../../modules/acm"
#   domain_name = "petclinic-dev.agklya.com"
#   zone_id     = data.aws_route53_zone.selected.zone_id
# }
