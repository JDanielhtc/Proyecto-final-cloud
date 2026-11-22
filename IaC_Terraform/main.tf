# Proveedor AWS configurado para FarmaExpress Perú S.A.C.
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

# 1. VPC Corporativa
resource "aws_vpc" "farmaexpress_vpc" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "VPC-FarmaExpress-Prod"
    Proyecto    = "Centro de Datos Cloud FarmaExpress"
    Ambiente    = "Producción"
  }
}

# 2. Subredes Públicas
resource "aws_subnet" "public_1a" {
  vpc_id                  = aws_vpc.farmaexpress_vpc.id
  cidr_block              = "10.10.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet-Public-Web-1A"
  }
}

resource "aws_subnet" "public_1b" {
  vpc_id                  = aws_vpc.farmaexpress_vpc.id
  cidr_block              = "10.10.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet-Public-Web-1B"
  }
}

# 3. Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.farmaexpress_vpc.id

  tags = {
    Name = "IGW-FarmaExpress"
  }
}

# 4. Tabla de Ruteo
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.farmaexpress_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "RT-Public-FarmaExpress"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.public_1b.id
  route_table_id = aws_route_table.public_rt.id
}