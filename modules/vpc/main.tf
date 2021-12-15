
resource "aws_vpc" "carlos" {
    cidr_block = var.vpc_cidr
    tags = {
        Name = "carlos-tf-vpc"
        ENV = var.env
    }
}
resource "aws_subnet" "priv1" {
    vpc_id = aws_vpc.carlos.id
    cidr_block = var.privSN1_cidr
    tags = {
        Name = "carlos-tf-privSN1"
        ENV = var.env
    }
}
resource "aws_subnet" "priv2" {
    vpc_id = aws_vpc.carlos.id
    cidr_block = var.privSN2_cidr
    tags = {
        Name = "carlos-tf-privSN2"
        ENV = var.env

    }
}
resource "aws_subnet" "priv3" {
    vpc_id = aws_vpc.carlos.id
    cidr_block = var.privSN3_cidr
    tags = {
        Name = "carlos-tf-privSN3"
        ENV = var.env

    }
}
resource "aws_subnet" "pub1" {
  vpc_id     = aws_vpc.carlos.id
  cidr_block = var.pubSN1_cidr
  tags = {
        Name = "carlos-tf-pubSN1"
        ENV = var.env
  }
}
resource "aws_subnet" "pub2" {
  vpc_id     = aws_vpc.carlos.id
  cidr_block = var.pubSN2_cidr
  tags = {
    Name = "carlos-tf-pubSN2"
    ENV = var.env

  }
}
resource "aws_subnet" "pub3" {
  vpc_id     = aws_vpc.carlos.id
  cidr_block = var.pubSN3_cidr
  tags = {
    Name = "carlos-tf-pubSN3"
    ENV = var.env

  }
}
resource "aws_internet_gateway" "carlos-tf-igw" {
  vpc_id = aws_vpc.carlos.id

  tags = {
    Name = "carlos-tf-igw"
    ENV = var.env

  }
}

resource "aws_eip" "carlos-tf-nat-eip" {
  vpc = true
  depends_on = [aws_internet_gateway.carlos-tf-igw]
  tags = {
      Name = "carlos-tf-nat-gw-eip"
      ENV = var.env

  }
}

resource "aws_nat_gateway" "carlos-tf-nat-gw" {
  allocation_id = aws_eip.carlos-tf-nat-eip.id
  subnet_id     = aws_subnet.pub1.id

  tags = {
    Name = "carlos-tf-nat-gw"
    ENV = var.env

  }
}

resource "aws_route_table" "carlos-tf-pubRT" {
  vpc_id = aws_vpc.carlos.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.carlos-tf-igw.id
  }
  tags = {
      Name = "carlos-tf-pubRT"
      ENV = var.env

  }
}
resource "aws_route_table_association" "pub1" {
  subnet_id      = aws_subnet.pub1.id
  route_table_id = aws_route_table.carlos-tf-pubRT.id
}
resource "aws_route_table_association" "pub2" {
  subnet_id      = aws_subnet.pub2.id
  route_table_id = aws_route_table.carlos-tf-pubRT.id
}
resource "aws_route_table_association" "pub3" {
  subnet_id      = aws_subnet.pub3.id
  route_table_id = aws_route_table.carlos-tf-pubRT.id
}
resource "aws_route_table" "carlos-tf-privRT" {
  vpc_id = aws_vpc.carlos.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.carlos-tf-nat-gw.id
  }
  tags = {
      Name = "carlos-tf-privRT"
      ENV = var.env

  }
}
resource "aws_route_table_association" "priv1" {
  subnet_id      = aws_subnet.priv1.id
  route_table_id = aws_route_table.carlos-tf-privRT.id
}
resource "aws_route_table_association" "priv2" {
  subnet_id      = aws_subnet.priv2.id
  route_table_id = aws_route_table.carlos-tf-privRT.id
}
resource "aws_route_table_association" "priv3" {
  subnet_id      = aws_subnet.priv3.id
  route_table_id = aws_route_table.carlos-tf-privRT.id
}