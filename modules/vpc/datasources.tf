data "aws_ami" "fck_nat" {
  filter {
    name   = "name"
    values = ["fck-nat-al2023-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners      = ["568608671756"]
  most_recent = true
}


data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}
