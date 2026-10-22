# main.tf — Composição de Módulos

# ========================================
# Módulo 1: VPC (base de tudo)
# ========================================
module "vpc" {
  source = "./modules/vpc-dynamic"

  vpc_cidr     = var.vpc_cidr
  project_name = var.project_name
  environment  = var.environment

  subnets = {
    "public-1" = { cidr = "10.0.1.0/24", az = "us-east-1a", type = "public" }
    "public-2" = { cidr = "10.0.2.0/24", az = "us-east-1b", type = "public" }
    "private-1" = { cidr = "10.0.3.0/24", az = "us-east-1a", type = "private" }
    "private-2" = { cidr = "10.0.4.0/24", az = "us-east-1b", type = "private" }
  }
}

# ========================================
# Módulo 2: Security Group API
# Composição: usa vpc_id do módulo VPC ↑
# ========================================
resource "aws_security_group" "api" {
  name        = "${var.project_name}-${var.environment}-api-sg"
  description = "Security Group para API"
  vpc_id      = module.vpc.vpc_id  # ← OUTPUT do módulo VPC

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-api-sg"
    Environment = var.environment
  }
}

# ========================================
# Data Source: AMI Amazon Linux 2023
# ========================================
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# ========================================
# Módulo 3: EC2
# Composição: usa subnet_id do VPC + sg_id
# ========================================
module "api_server" {
  source = "./modules/ec2"

  instance_name      = "${var.project_name}-${var.environment}-api"
  instance_type      = "t2.micro"
  ami_id             = data.aws_ami.amazon_linux.id
  subnet_id          = module.vpc.public_subnet_ids[0]   # ← OUTPUT do VPC
  security_group_ids = [aws_security_group.api.id]       # ← OUTPUT do SG
  key_name           = var.key_name
  environment        = var.environment
  project_name       = var.project_name
}