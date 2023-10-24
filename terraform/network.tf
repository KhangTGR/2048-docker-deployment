resource "aws_vpc" "vpc" {
  cidr_block           = var.network.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge({
    Name = "${var.prefix}-${var.network.name}"
  }, var.network.tags)
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = merge({
    Name = "${var.prefix}-${var.network.name}-igw"
  }, var.network.tags)
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.network.public_subnets_cidr_block)
  cidr_block              = element(var.network.public_subnets_cidr_block, count.index)
  availability_zone       = element(var.network.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = merge({
    Name = "${var.prefix}-${var.network.name}-public-subnet-${element(var.network.availability_zones, count.index)}"
  }, var.network.tags)
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.network.private_subnets_cidr_block)
  cidr_block              = element(var.network.private_subnets_cidr_block, count.index)
  availability_zone       = element(var.network.availability_zones, count.index)
  map_public_ip_on_launch = false

  tags = merge({
    Name = "${var.prefix}-${var.network.name}-private-subnet-${element(var.network.availability_zones, count.index)}"
  }, var.network.tags)
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = merge({
    Name = "${var.prefix}-${var.network.name}-private-route-table"
  }, var.network.tags)
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = merge({
    Name = "${var.prefix}-${var.network.name}-public-route-table"
  }, var.network.tags)
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.network.public_subnets_cidr_block)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.network.private_subnets_cidr_block)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "security_group" {
  name        = "${var.prefix}-${var.network.name}-security-group"
  description = "Default SG to allow traffic from the VPC"
  vpc_id      = aws_vpc.vpc.id

  depends_on = [
    aws_vpc.vpc
  ]

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

  tags = merge({}, var.network.tags)
}
