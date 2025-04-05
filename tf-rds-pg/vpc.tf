resource "aws_vpc" "quasar_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "quasar-vpc"
  }
}

resource "aws_subnet" "quasar_subnet_1" {
  vpc_id            = aws_vpc.quasar_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-north-1a"

  tags = {
    Name = "quasar-subnet-1"
  }
}

resource "aws_subnet" "quasar_subnet_2" {
  vpc_id            = aws_vpc.quasar_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-north-1b"

  tags = {
    Name = "quasar-subnet-2"
  }
}

resource "aws_internet_gateway" "quasar_igw" {
  vpc_id = aws_vpc.quasar_vpc.id

  tags = {
    Name = "quasar-igw"
  }
}

resource "aws_route_table" "quasar_rt" {
  vpc_id = aws_vpc.quasar_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.quasar_igw.id
  }

  tags = {
    Name = "quasar-rt"
  }
}

resource "aws_route_table_association" "rt_assoc_1" {
  subnet_id      = aws_subnet.quasar_subnet_1.id
  route_table_id = aws_route_table.quasar_rt.id
}

resource "aws_route_table_association" "rt_assoc_2" {
  subnet_id      = aws_subnet.quasar_subnet_2.id
  route_table_id = aws_route_table.quasar_rt.id
}

resource "aws_security_group" "quasar_sg" {
  name        = "quasar-rds-sg"
  description = "Allow PostgreSQL"
  vpc_id      = aws_vpc.quasar_vpc.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ⚠️ Publicly open for now
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "quasar-rds-sg"
  }
}
