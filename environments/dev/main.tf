module "vpc" {
  source               = "../../modules/vpc"
  cidr_block           = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  secure_subnet_cidrs  = ["10.0.5.0/24", "10.0.6.0/24"]
  azs                  = ["us-east-1a", "us-east-1b"]
  name                 = "dev-pet-clinic"
}
