# EC2 instance in private subnet AZ1
resource "aws_instance" "EC2-Private-Instance-AZ1" {
  ami           = "ami-052c9ea013e6e3567"  # Replace with your AMI ID
  instance_type = "t2.micro"
  subnet_id     = var.private_app_subnet_az1_id
  security_groups = [var.alb_security_group_id]

  tags = {
    Name = "EC2-Private-Instance-AZ1"
  }
}

# EC2 instance in private subnet AZ2
resource "aws_instance" "EC2-Private-Instance-AZ2" {
  ami           = "ami-052c9ea013e6e3567"  # Replace with your AMI ID
  instance_type = "t2.micro"
  subnet_id     = var.private_app_subnet_az2_id
  security_groups = [var.alb_security_group_id]

  tags = {
    Name = "EC2-Private-Instance_AZ2"
  }
}

# EC2 instance in Public subnet AZ1
resource "aws_instance" "EC2-Public-Instance-AZ1" {
  ami           = "ami-052c9ea013e6e3567"  # Replace with your AMI ID
  instance_type = "t2.micro"
  subnet_id     = var.public_subnet_az1_id
  security_groups = [var.alb_security_group_id]

  tags = {
    Name = "EC2-Public-Instance-AZ1"
  }
}

# EC2 instance in Public subnet AZ2
resource "aws_instance" "EC2-Public-Instance-AZ2" {
  ami           = "ami-052c9ea013e6e3567"  # Replace with your AMI ID
  instance_type = "t2.micro"
  subnet_id     = var.public_subnet_az2_id
  security_groups = [var.alb_security_group_id]

  tags = {
    Name = "EC2-Public-Instance-AZ2"
  }
}

