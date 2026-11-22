# ==============================================================================
# PROYECTO INTEGRADOR: CENTRO DE DATOS CLOUD FARMAEXPRESS PERÚ S.A.C.
# Automatización de Infraestructura de Red con Terraform
# ==============================================================================

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# 1. Creación de la VPC de Producción
resource "aws_vpc" "farmaexpress_vpc" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name     = "VPC-FarmaExpress-Prod"
    Ambiente = "Producción"
    Proyecto = "Centro de Datos Cloud FarmaExpress"
  }
}

# 2. Creación del Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.farmaexpress_vpc.id

  tags = {
    Name     = "IGW-FarmaExpress"
    Proyecto = "Centro de Datos Cloud FarmaExpress"
  }
}

# 3. Creación de la Tabla de Enrutamiento Pública
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.farmaexpress_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name     = "RT-Public-FarmaExpress"
    Proyecto = "Centro de Datos Cloud FarmaExpress"
  }
}

# 4. Creación de Subredes Públicas (Multi-AZ)
resource "aws_subnet" "subnet_public_1a" {
  vpc_id                  = aws_vpc.farmaexpress_vpc.id
  cidr_block              = "10.10.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet-Public-Web-1A"
  }
}

resource "aws_subnet" "subnet_public_1b" {
  vpc_id                  = aws_vpc.farmaexpress_vpc.id
  cidr_block              = "10.10.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet-Public-Web-1B"
  }
}
