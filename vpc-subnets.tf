module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = var.Environment
  }
}

resource "aws_subnet" "public_subnets" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnets

  tags = {
    Name = "public_subnets"
    Environment = var.Environment
  }
}

resource "aws_subnet" "private_subnets" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnets

  tags = {
    Name = "private_subnets"
    Environment = var.Environment
  }
}
