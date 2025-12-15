data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name               = "${var.environment}-${var.application_name}-vpc"
    Environment        = var.environment
    Application        = var.application_name
    Owner              = var.owner
    CostCenter         = var.cost_center
    DataClassification = var.data_classification
  }
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name               = "${var.environment}-${var.application_name}-public-subnet-${count.index + 1}"
    Environment        = var.environment
    Application        = var.application_name
    Owner              = var.owner
    CostCenter         = var.cost_center
    DataClassification = var.data_classification
  }
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name               = "${var.environment}-${var.application_name}-private-subnet-${count.index + 1}"
    Environment        = var.environment
    Application        = var.application_name
    Owner              = var.owner
    CostCenter         = var.cost_center
    DataClassification = var.data_classification
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name               = "${var.environment}-${var.application_name}-igw"
    Environment        = var.environment
    Application        = var.application_name
    Owner              = var.owner
    CostCenter         = var.cost_center
    DataClassification = var.data_classification
  }
}

resource "aws_eip" "nat" {
  count  = length(var.public_subnet_cidrs)
  domain = "vpc"

  tags = {
    Name               = "${var.environment}-${var.application_name}-nat-eip-${count.index + 1}"
    Environment        = var.environment
    Application        = var.application_name
    Owner              = var.owner
    CostCenter         = var.cost_center
    DataClassification = var.data_classification
  }
}

resource "aws_nat_gateway" "main" {
  count         = length(var.public_subnet_cidrs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  depends_on    = [aws_internet_gateway.main]

  tags = {
    Name               = "${var.environment}-${var.application_name}-nat-gw-${count.index + 1}"
    Environment        = var.environment
    Application        = var.application_name
    Owner              = var.owner
    CostCenter         = var.cost_center
    DataClassification = var.data_classification
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name               = "${var.environment}-${var.application_name}-public-rt"
    Environment        = var.environment
    Application        = var.application_name
    Owner              = var.owner
    CostCenter         = var.cost_center
    DataClassification = var.data_classification
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }

  tags = {
    Name               = "${var.environment}-${var.application_name}-private-rt-${count.index + 1}"
    Environment        = var.environment
    Application        = var.application_name
    Owner              = var.owner
    CostCenter         = var.cost_center
    DataClassification = var.data_classification
  }
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = aws_route_table.private[*].id

  tags = {
    Name               = "${var.environment}-${var.application_name}-s3-endpoint"
    Environment        = var.environment
    Application        = var.application_name
    Owner              = var.owner
    CostCenter         = var.cost_center
    DataClassification = var.data_classification
  }
}
