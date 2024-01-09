// Create VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    {
      "Name" = "${var.env}-${var.project_name}-vpc"
    },
    var.tags,
  )
}

// Create public subnet1 for VPC
resource "aws_subnet" "public_subnet1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet1_cidr_block
  availability_zone = var.availability_zone1

  tags = merge(
    {
      "Name" = "${var.env}-${var.project_name}-public-subnet1"
    },
    var.tags,
  )
}

// Create public subnet2 for VPC
resource "aws_subnet" "public_subnet2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet2_cidr_block
  availability_zone = var.availability_zone2

  tags = merge(
    {
      "Name" = "${var.env}-${var.project_name}-public-subnet2"
    },
    var.tags,
  )
}

// Create private subnet1 for VPC
resource "aws_subnet" "private_subnet1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet1_cidr_block
  availability_zone = var.availability_zone1

  tags = merge(
    {
      "Name" = "${var.env}-${var.project_name}-private-subnet1"
    },
    var.tags,
  )
}

// Create private subnet2 for VPC
resource "aws_subnet" "private_subnet2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet2_cidr_block
  availability_zone = var.availability_zone2

  tags = merge(
    {
      "Name" = "${var.env}-${var.project_name}-private-subnet2"
    },
    var.tags,
  )
}

// Create Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      "Name" = "${var.env}-${var.project_name}"
    },
    var.tags,
  )
}

// Create route on IGW on VPC default rtb
resource "aws_default_route_table" "vpc_default_rtb" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  # Internet gtw route
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    {
      "Name" = "${var.env}-${var.project_name}-vpc-default-rtb"
    },
    var.tags,
  )
}

// Associate public subnet1 with VPC
resource "aws_route_table_association" "public_subnet1_rtb_association" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_default_route_table.vpc_default_rtb.id
}

# Associate public subnet2 with VPC
resource "aws_route_table_association" "public_subnet2_rtb_association" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_default_route_table.vpc_default_rtb.id
}

# Create custom private route table 1 
resource "aws_route_table" "private_rtb1" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      "Name" = "${var.env}-${var.project_name}-rtb1"
    },
    var.tags,
  )
}

// Create custom private route table 2
resource "aws_route_table" "private_rtb2" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    {
      "Name" = "${var.env}-${var.project_name}-rtb2"
    },
    var.tags,
  )
}

// Create EIP for nat1
resource "aws_eip" "eip1" {
  domain = "vpc"

  tags = merge(
    {
      "Name" = "${var.env}-${var.project_name}-eip1"
    },
    var.tags,
  )
}

// Create EIP for nat2
resource "aws_eip" "eip2" {
  domain = "vpc"

  tags = merge(
    {
      "Name" = "${var.env}-${var.project_name}-eip2"
    },
    var.tags,
  )
}

// Create NAT GTW1
resource "aws_nat_gateway" "nat_gtw1" {
  allocation_id = aws_eip.eip1.id
  subnet_id     = aws_subnet.public_subnet1.id

  tags = merge(
    {
      "Name" = "${var.env}-${var.project_name}-nat-gtw1"
    },
    var.tags,
  )
}

// Create NAT GTW2
resource "aws_nat_gateway" "nat_gtw2" {
  allocation_id = aws_eip.eip2.id
  subnet_id     = aws_subnet.public_subnet2.id

  tags = merge(
    {
      "Name" = "${var.env}-${var.project_name}-nat-gtw2"
    },
    var.tags,
  )
}

// Configure nat gtw route on private route table 1
resource "aws_route" "private_rtb1_nat_gtw1" {
  route_table_id         = aws_route_table.private_rtb1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gtw1.id
}

// Configure nat gtw route on private route table 2
resource "aws_route" "private_rtb2_nat_gtw2" {
  route_table_id         = aws_route_table.private_rtb2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gtw2.id
}

// Associate private subnet1 with VPC
resource "aws_route_table_association" "private_subnet1_rtb_association" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private_rtb1.id
}

// Associate private subnet2 with VPC
resource "aws_route_table_association" "private_subnet2_rtb_association" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private_rtb2.id
}

resource "aws_security_group" "default" {
  name        = "${var.env}-${var.project_name}-sg-vpc"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = "true"
  }
}