module "db" {
  source = "../modules/ec2"

  instance_name     = "${module.vpc.vpc_name}-database"
  instance_type     = "t3.micro"
  ami_id            = "ami-0a998385ed9f45655"
  subnet_id         = module.vpc.subnets["infraworkshop-apne2-private-subnet-c"].id
  security_group_id = module.vpc.security_groups["infraworkshop-apne2-internal-permit-security-group"].id
  keypair_name      = "${module.vpc.vpc_name}-keypair"
  availability_zone = "ap-northeast-2c"
  ebs_volume_size   = 8
  ebs_volume_name   = "${module.vpc.vpc_name}-database-ebs"
}
