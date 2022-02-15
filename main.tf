provider "aws" {
  region = var.region
}

resource "aws_vpc" "nextcloud_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "nextcloud"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.nextcloud_vpc.id

  tags = {
    Name = "nextcloud_gateway"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "gw NAT"
  }

  depends_on = [aws_internet_gateway.gw]
}
