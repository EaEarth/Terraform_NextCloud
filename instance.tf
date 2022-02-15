data "template_file" "app_instance_script" {
  template = "${file("./scripts/app_instance.sh")}"

  vars = {
    database_name   = var.database_name
    database_user   = var.database_user
    database_pass   = var.database_pass
    database_host   = aws_network_interface.db_to_app.private_ip
    admin_user      = var.admin_user
    admin_pass      = var.admin_pass
    bucket_name     = var.bucket_name
    region          = var.region
    user_access_key = aws_iam_access_key.nextcloud_access_key.id
    user_secret_key = aws_iam_access_key.nextcloud_access_key.secret
  }
}

resource "aws_instance" "app_instance" {
  ami               = var.ami
  instance_type     = "t2.micro"
  availability_zone = var.availability_zone
  key_name          = var.key_name

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.app.id
  }

  network_interface {
    device_index         = 1
    network_interface_id = aws_network_interface.app_to_db.id
  }

  user_data = "${data.template_file.app_instance_script.rendered}"
  tags = {
    Name = "web-server"
  }
}

data "template_file" "db_instance_script" {
  template = "${file("./scripts/db_instance.sh")}"

  vars = {
    database_user = var.database_user
    database_pass = var.database_pass
    database_name = var.database_name
  }
}


resource "aws_instance" "db_instance" {
  ami               = var.ami
  instance_type     = "t2.micro"
  availability_zone = var.availability_zone
  key_name          = var.key_name

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.db.id
  }

  network_interface {
    device_index         = 1
    network_interface_id = aws_network_interface.db_to_app.id
  }

  user_data = "${data.template_file.db_instance_script.rendered}"
  tags = {
    Name = "db-server"
  }
}