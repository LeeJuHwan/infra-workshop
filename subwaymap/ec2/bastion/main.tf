locals {
  subnet_id         = data.terraform_remote_state.vpc.outputs.subnets["infraworkshop-apne2-public-subnet-c"].id
  security_group_id = data.terraform_remote_state.vpc.outputs.security_groups["infraworkshop-apne2-admin-permit-security-group"].id
}

resource "aws_instance" "bastion" {
  ami                    = "ami-0a998385ed9f45655"
  instance_type          = "t3.micro"
  subnet_id              = local.subnet_id
  vpc_security_group_ids = [local.security_group_id]


  tags = {
    Name = "infraworkshop-apne2-bastion"
  }
}
