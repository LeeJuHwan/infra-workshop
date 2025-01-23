resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "keypair" {
  key_name   = var.keypair_name
  public_key = tls_private_key.key.public_key_openssh
}

resource "local_file" "local_keypair" {
  filename        = "../keypair/${var.keypair_name}.pem"
  content         = tls_private_key.key.private_key_pem
  file_permission = "0400"
}

resource "aws_instance" "bastion" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = aws_key_pair.keypair.key_name


  tags = {
    Name = var.bastion_instance_name
  }
}
