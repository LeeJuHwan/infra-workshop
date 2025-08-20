locals {
  vpc_config = yamldecode(file("config/vpc_config.yaml"))
  rds_config = yamldecode(file("config/rds_config.yaml"))
}

module "vpc" {
  source = "../modules/vpc"

  vpc_name        = local.vpc_config.vpc_name
  subnets         = local.vpc_config.subnets
  cidr_block      = local.vpc_config.cidr_block
  security_groups = local.vpc_config.security_groups
  ingress_rules   = local.vpc_config.ingress_rules
  egress_rules    = local.vpc_config.egress_rules
}

module "was-01" {
  source = "../modules/ec2"

  instance_name     = "${module.vpc.vpc_name}-was-01"
  instance_type     = "t3.medium"
  ami_id            = "ami-0a998385ed9f45655"
  subnet_id         = module.vpc.subnets["infraworkshop-apne2-public-subnet-a"].id
  security_group_id = module.vpc.security_groups["infraworkshop-apne2-external-permit-security-group"].id
  keypair_name      = "${module.vpc.vpc_name}-keypair"
  availability_zone = module.vpc.subnets["infraworkshop-apne2-public-subnet-a"].availability_zone
  ebs_volume_size   = 8
  ebs_volume_name   = "${module.vpc.vpc_name}-was-01-ebs"
}

module "was-02" {
  source            = "../modules/ec2"
  instance_name     = "${module.vpc.vpc_name}-was-02"
  instance_type     = "t3.medium"
  ami_id            = "ami-0a998385ed9f45655"
  subnet_id         = module.vpc.subnets["infraworkshop-apne2-public-subnet-c"].id
  security_group_id = module.vpc.security_groups["infraworkshop-apne2-external-permit-security-group"].id
  keypair_name      = "${module.vpc.vpc_name}-keypair"
  availability_zone = module.vpc.subnets["infraworkshop-apne2-public-subnet-c"].availability_zone
  ebs_volume_size   = 8
  ebs_volume_name   = "${module.vpc.vpc_name}-was-02-ebs"
}

module "bastion" {
  source = "../modules/bastion"

  bastion_instance_name = "${module.vpc.vpc_name}-bastion"
  instance_type         = "t3.micro"
  ami_id                = "ami-0a998385ed9f45655"
  subnet_id             = module.vpc.subnets["infraworkshop-apne2-management-subnet-a"].id
  availability_zone     = module.vpc.subnets["infraworkshop-apne2-management-subnet-a"].availability_zone
  security_group_id     = module.vpc.security_groups["infraworkshop-apne2-admin-permit-security-group"].id
  keypair_name          = "${module.vpc.vpc_name}-keypair"
  bastion_volume_name   = "${module.vpc.vpc_name}-ebs"
  bastion_volume_size   = 8
}

resource "aws_key_pair" "keypair" {
  key_name   = "${module.vpc.vpc_name}-keypair"
  public_key = file("../keypair/infraworkshop-apne2-keypair.pub")
}

module "rds" {
  source = "../modules/rds"

  db_name                = local.rds_config.db_name
  username               = local.rds_config.username
  password               = local.rds_config.password
  db_engine              = local.rds_config.db_engine
  db_engine_version      = local.rds_config.db_engine_version
  vpc_security_group_ids = [module.vpc.security_groups["infraworkshop-apne2-internal-permit-security-group"].id]
  rds_private_subnet_ids = [
    module.vpc.subnets["infraworkshop-apne2-private-subnet-a"].id,
    module.vpc.subnets["infraworkshop-apne2-private-subnet-c"].id,
  ]
}
