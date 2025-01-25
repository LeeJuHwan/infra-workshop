resource "aws_ebs_volume" "ebs-volume" {
  availability_zone = var.availability_zone
  size              = var.ebs_volume_size
  type              = "gp3"
  tags = {
    Name = var.ebs_volume_name
  }
}

resource "aws_instance" "instance" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.keypair_name


  tags = {
    Name = var.instance_name
  }
}


resource "aws_volume_attachment" "ebs-volume-attachment" {
  device_name                    = "/dev/xvdh"
  volume_id                      = aws_ebs_volume.ebs-volume.id
  instance_id                    = aws_instance.instance.id
  stop_instance_before_detaching = true
}
