module "bastion" {
  source = "../modules/bastion"

  bastion_instance_name = "${module.vpc.vpc_name}-bastion"
  instance_type         = "t3.micro"
  ami_id                = "ami-0a998385ed9f45655"
  subnet_id             = module.vpc.subnets["infraworkshop-apne2-management-subnet-c"].id
  security_group_id     = module.vpc.security_groups["infraworkshop-apne2-admin-permit-security-group"].id
  keypair_name          = "${module.vpc.vpc_name}-keypair"
  availability_zone     = "ap-northeast-2c"
  bastion_volume_name   = "${module.vpc.vpc_name}-ebs"
  bastion_volume_size   = 8
}
