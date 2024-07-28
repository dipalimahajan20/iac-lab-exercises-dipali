resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  instance_tenancy     = "default"

  tags = {
    Name = "iac-lab-dipali"
  }
}

resource "random_pet" "this" {
  length = 1
}

#add 6 x subnet resources into this file.
resource "aws_subnet" "pubsub1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet1_cidr
  availability_zone = "ap-southeast-2a"

  tags = {
    Name = "pubsub1"
  }
}
resource "aws_subnet" "prisub1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet2_cidr
  availability_zone = "ap-southeast-2a"

  tags = {
    Name = "prisub1"
  }
}
resource "aws_subnet" "secsub1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet3_cidr
  availability_zone = "ap-southeast-2a"

  tags = {
    Name = "secsub1"
  }
}
resource "aws_subnet" "pubsub2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet4_cidr
  availability_zone = "ap-southeast-2b"

  tags = {
    Name = "pubsub2"
  }
}
resource "aws_subnet" "prisub2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet5_cidr
  availability_zone = "ap-southeast-2b"

  tags = {
    Name = "prisub2"
  }
}
resource "aws_subnet" "secsub2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet6_cidr
  availability_zone = "ap-southeast-2b"

  tags = {
    Name = "secsub2"
  }
}

# Add the following resources:
#1 x internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "aws_internet_gateway"
  }
}

#1 x Elastic IP
resource "aws_eip" "nat" {
  domain = "vpc"
}

#1 x NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.pubsub1.id

  tags = {
    Name = "aws_nat_gateway"
  }
}

#add 2 x Route Table resources, one for public routing and one for private routing
resource "aws_route_table" "public_routetable" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = format("%s-%s-public-route-table", var.prefix, random_pet.this.id)
  }
}

resource "aws_route_table" "private_routetable" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = format("%s-%s-private-route-table", var.prefix, random_pet.this.id)
  }
}

#add 4 x Route Table Association resources, create an association between a route table and a subnet
resource "aws_route_table_association" "public_subnet_1" {
  subnet_id      = aws_subnet.pubsub1.id
  route_table_id = aws_route_table.public_routetable.id
}


resource "aws_route_table_association" "public_subnet_2" {
  subnet_id      = aws_subnet.pubsub2.id
  route_table_id = aws_route_table.public_routetable.id
}


resource "aws_route_table_association" "private_subnet_1" {
  subnet_id      = aws_subnet.prisub1.id
  route_table_id = aws_route_table.private_routetable.id
}


resource "aws_route_table_association" "private_subnet_2" {
  subnet_id      = aws_subnet.prisub2.id
  route_table_id = aws_route_table.private_routetable.id
}