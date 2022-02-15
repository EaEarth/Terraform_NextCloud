resource "aws_security_group" "app_security_group" {
  name        = "allow_app_traffic"
  description = "Allow App inbound traffic"
  vpc_id      = aws_vpc.nextcloud_vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app_sg"
  }
}

resource "aws_security_group" "app_db_security_group" {
  name        = "allow_traffic_from_app"
  description = "Allow inbound traffic from app"
  vpc_id      = aws_vpc.nextcloud_vpc.id

  ingress {
    description = "MySQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    self        = true
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  tags = {
    Name = "app_db_sg"
  }
}

resource "aws_security_group" "db_security_group" {
  name        = "not_allow_inbound_traffic"
  description = "Not allow inbound traffic"
  vpc_id      = aws_vpc.nextcloud_vpc.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  } 

  tags = {
    Name = "db_sg"
  }
}