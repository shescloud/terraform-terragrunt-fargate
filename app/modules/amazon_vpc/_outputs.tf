// VPC 
output "vpc_arn" {
  value = aws_vpc.vpc.arn
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_main_rtb" {
  value = aws_vpc.vpc.main_route_table_id
}

output "vpc_cidr_block" {
  value = aws_vpc.vpc.cidr_block
}

// Public Subnet1
output "public_subnet1_id" {
  value = aws_subnet.public_subnet1.id
}

output "public_subnet1_cidr_block" {
  value = aws_subnet.public_subnet1.cidr_block
}

output "public_subnet1_az" {
  value = aws_subnet.public_subnet1.availability_zone
}

output "public_subnet1_az_id" {
  value = aws_subnet.public_subnet1.availability_zone_id
}

// Public Subnet2
output "public_subnet2_id" {
  value = aws_subnet.public_subnet2.id
}

output "public_subnet2_cidr_block" {
  value = aws_subnet.public_subnet2.cidr_block
}

output "public_subnet2" {
  value = aws_subnet.public_subnet2.availability_zone
}

output "public_subnet2_az_id" {
  value = aws_subnet.public_subnet2.availability_zone_id
}

// Private Subnet1
output "private_subnet1_id" {
  value = aws_subnet.private_subnet1.id
}

output "private_subnet1_cidr_block" {
  value = aws_subnet.private_subnet1.cidr_block
}

output "private_subnet1_az" {
  value = aws_subnet.private_subnet1.availability_zone
}

output "private_subnet1_az_id" {
  value = aws_subnet.private_subnet1.availability_zone_id
}

// Private Subnet az2
output "private_subnet2_id" {
  value = aws_subnet.private_subnet2.id
}

output "private_subnet2_cidr_block" {
  value = aws_subnet.private_subnet2.cidr_block
}

output "private_subnet2_az" {
  value = aws_subnet.private_subnet2.availability_zone
}

output "private_subnet2_az_id" {
  value = aws_subnet.public_subnet2.availability_zone_id
}

// IGW 
output "igw_id" {
  value = aws_internet_gateway.igw.id
}

// Default rtb
output "default_rtb_id" {
  value = aws_default_route_table.vpc_default_rtb.id
}  