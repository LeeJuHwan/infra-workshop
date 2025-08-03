resource "aws_ebs_volume" "bastion-ebs-volume" {
  availability_zone = var.availability_zone
  size              = var.bastion_volume_size
  type              = "gp3"
  tags = {
    Name = var.bastion_volume_name
  }
}

resource "aws_instance" "bastion" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.keypair_name


  tags = {
    Name = var.bastion_instance_name
  }
}


resource "aws_volume_attachment" "ebs-volume-attachment" {
  device_name                    = "/dev/xvdh"
  volume_id                      = aws_ebs_volume.bastion-ebs-volume.id
  instance_id                    = aws_instance.bastion.id
  stop_instance_before_detaching = true
}
