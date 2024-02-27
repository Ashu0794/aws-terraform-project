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




# resource "aws_instance" "example" {
#   ami           = "ami-052c9ea013e6e3567"
#   instance_type = "t2.micro"
#   subnet_id = module.vpc.public_subnet_az1_id
#   vpc_security_group_ids = [module.security_groups.alb_security_group_id]
#   tags = {
#     Name = "ExampleInstance"
#   }
# }

# resource "aws_security_group" "TF_SG" {
#   name        = "security group using Terraform"
#   description = "security group using Terraform"
#   vpc_id      = module.vpc.vpc_id

#   ingress {
#     description      = "HTTPS"
#     from_port        = 443
#     to_port          = 443
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   ingress {
#     description      = "HTTP"
#     from_port        = 80
#     to_port          = 80
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   ingress {
#     description      = "SSH"
#     from_port        = 22
#     to_port          = 22
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   tags = {
#     Name = "TF_SG"
#   }
# }

# EC2 instance in private subnet
resource "aws_instance" "example" {
  ami           = "ami-052c9ea013e6e3567"  # Replace with your AMI ID
  instance_type = "t2.micro"
  subnet_id     = module.vpc.private_app_subnet_az1_id
  security_groups = [module.security_groups.alb_security_group_id]

  // Other configuration for your EC2 instance
}