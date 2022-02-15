resource "aws_network_interface" "app" {
  subnet_id       = aws_subnet.public_subnet.id
  private_ips     = ["10.0.1.10"]
  security_groups = [aws_security_group.app_security_group.id]

  tags = {
    Name = "app"
  }
}

resource "aws_network_interface" "app_to_db" {
  subnet_id       = aws_subnet.app_db_subnet.id
  private_ips     = ["10.0.2.10"]
  security_groups = [aws_security_group.app_db_security_group.id]

  tags = {
    Name = "app_to_db"
  }
}

resource "aws_network_interface" "db_to_app" {
  subnet_id       = aws_subnet.app_db_subnet.id
  private_ips     = ["10.0.2.11"]
  security_groups = [aws_security_group.app_db_security_group.id]

  tags = {
    Name = "db_to_app"
  }
}

resource "aws_network_interface" "db" {
  subnet_id       = aws_subnet.private_subnet.id
  private_ips     = ["10.0.3.10"]
  security_groups = [aws_security_group.db_security_group.id]

  tags = {
    Name = "db"
  }
}

resource "aws_eip" "nat" {
  vpc                       = true

  tags = {
    Name = "Nat eip"
  }
}

resource "aws_eip" "app" {
  vpc                       = true
  network_interface         = aws_network_interface.app.id

  tags = {
    Name = "App eip"
  }

  depends_on = [aws_network_interface.app]
}