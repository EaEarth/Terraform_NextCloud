resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.nextcloud_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.availability_zone

  tags = {
    Name = "nextcloud_public_subnet"
  }
}

resource "aws_subnet" "app_db_subnet" {
  vpc_id            = aws_vpc.nextcloud_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.availability_zone

  tags = {
    Name = "app_db_private_subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.nextcloud_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = var.availability_zone

  tags = {
    Name = "db_private_subnet"
  }
}