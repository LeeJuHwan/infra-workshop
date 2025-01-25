resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "keypair" {
  key_name   = "${module.vpc.vpc_name}-keypair"
  public_key = tls_private_key.key.public_key_openssh
}

resource "local_file" "local_keypair" {
  filename        = "../keypair/${module.vpc.vpc_name}-keypair.pem"
  content         = tls_private_key.key.private_key_pem
  file_permission = "0400"
}
