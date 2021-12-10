provider "aws" {
    region = "us-east-2"
}

resource "aws_vpc" "carlos" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "carlos-terraform-vpc"
    }
}
resource "aws_subnet" "private1" {
    vpc_id = aws_vpc.carlos.id
    cidr_block = "10.0.0.0/24"
    tags = {
        Name = "carlos-terraform-private-subnet1"
    }
}
resource "aws_subnet" "private2" {
    vpc_id = aws_vpc.carlos.id
    cidr_block = "10.0.3.0/24"
    tags = {
        Name = "carlos-terraform-private-subnet2"
    }
}
resource "aws_subnet" "private3" {
    vpc_id = aws_vpc.carlos.id
    cidr_block = "10.0.2.0/24"
    tags = {
        Name = "carlos-terraform-private-subnet3"
    }
}
resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.carlos.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "carlos-terraform-public-subnet1"
  }
}
resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.carlos.id
  cidr_block = "10.0.5.0/24"

  tags = {
    Name = "carlos-terraform-public-subnet2"
  }
}
resource "aws_subnet" "public3" {
  vpc_id     = aws_vpc.carlos.id
  cidr_block = "10.0.6.0/24"

  tags = {
    Name = "carlos-terraform-public-subnet3"
  }
}
resource "aws_internet_gateway" "carlos-igw" {
  vpc_id = aws_vpc.carlos.id

  tags = {
    Name = "carlos-igw"
  }
}

resource "aws_eip" "carlos-nat-eip" {
  vpc = true
  depends_on = [aws_internet_gateway.carlos-igw]
  tags = {
      Name = "carlos-nat-gateway-eip"
  }
}

resource "aws_nat_gateway" "carlos-terraform-nat-gw" {
  allocation_id = aws_eip.carlos-nat-eip.id
  subnet_id     = aws_subnet.public1.id

  tags = {
    Name = "carlos-terraform-nat-gw"
  }
}

resource "aws_route_table" "carlos-terraform-public-rt" {
  vpc_id = aws_vpc.carlos.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.carlos-igw.id
  }
  tags = {
      Name = "carlos-terraform-public-rt"
  }
}
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.carlos-terraform-public-rt.id
}
resource "aws_route_table" "carlos-terraform-private-rt" {
  vpc_id = aws_vpc.carlos.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.carlos-terraform-nat-gw.id
  }
  tags = {
      Name = "carlos-terraform-private-rt"
  }
}
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.carlos-terraform-private-rt.id
}

terraform {
  backend "s3" {
    bucket = "carlos-nclouds-bucket"
    key    = "terraform/terraform.tfstate"
    region = "us-west-2"
  }
}