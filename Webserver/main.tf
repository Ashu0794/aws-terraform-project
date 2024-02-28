provider "aws" {
  region     = var.region
  access_key = "AKIARSX3EA4TZGD5G5PK"
  secret_key = "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"
}

#create vpc
module "vpc" {
  source                       = "../modules/vpc"
  region                       = var.region
  project_name                 = var.project_name
  vpc_cidr                     = var.vpc_cidr
  public_subnet_az1_cidr       = var.public_subnet_az1_cidr
  public_subnet_az2_cidr       = var.public_subnet_az2_cidr
  private_app_subnet_az1_cidr  = var.private_app_subnet_az1_cidr
  private_app_subnet_az2_cidr  = var.private_app_subnet_az2_cidr
  private_data_subnet_az1_cidr = var.private_data_subnet_az1_cidr
  private_data_subnet_az2_cidr = var.private_data_subnet_az2_cidr



}

#Create NAT Gateway
module "nat_gateway" {
  source                     = "../modules/nat-gateway"
  public_subnet_az1_id       = module.vpc.public_subnet_az1_id
  internet_gateway           = module.vpc.internet_gateway
  public_subnet_az2_id       = module.vpc.public_subnet_az2_id
  vpc_id                     = module.vpc.vpc_id
  private_app_subnet_az1_id  = module.vpc.private_app_subnet_az1_id
  private_data_subnet_az1_id = module.vpc.private_data_subnet_az1_id
  private_app_subnet_az2_id  = module.vpc.private_app_subnet_az2_id
  private_data_subnet_az2_id = module.vpc.private_data_subnet_az2_id

}

# Create security group
module "security_groups" {
  source = "../modules/security-group"
  vpc_id = module.vpc.vpc_id

}  

module "ecs_tasks_execution_role" {
  source = "../modules/ecs-task-execution-role"
  project_name = module.vpc.project_name
}

module "application_load_balancer" {
  source = "../modules/alb"
  project_name = module.vpc.project_name
  alb_security_group_id = module.security_groups.alb_security_group_id
  public_subnet_az1_id = module.vpc.public_subnet_az1_id
  public_subnet_az2_id = module.vpc.public_subnet_az2_id
  vpc_id = module.vpc.vpc_id
}



module "ec2_instance" {
  source = "../modules/ec2-instance"
  private_app_subnet_az1_id  = module.vpc.private_app_subnet_az1_id
  alb_security_group_id = module.security_groups.alb_security_group_id
  private_app_subnet_az2_id  = module.vpc.private_app_subnet_az2_id
  public_subnet_az1_id       = module.vpc.public_subnet_az1_id
  public_subnet_az2_id       = module.vpc.public_subnet_az2_id
}
