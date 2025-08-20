resource "aws_db_instance" "rds" {
  identifier                   = var.db_name
  instance_class               = "db.t3.micro"
  allocated_storage            = 20
  storage_type                 = "gp3"
  engine                       = var.db_engine
  engine_version               = var.db_engine_version
  db_name                      = var.db_name
  username                     = var.username
  password                     = var.password
  vpc_security_group_ids       = var.vpc_security_group_ids
  db_subnet_group_name         = aws_db_subnet_group.rds_sg.name
  publicly_accessible          = true
  multi_az                     = false
  backup_retention_period      = 7
  skip_final_snapshot          = true
  performance_insights_enabled = false
  deletion_protection          = false

  tags = {
    name = "rds-${var.db_name}-${var.db_engine}:${var.db_engine_version}"
  }
}

resource "aws_db_subnet_group" "rds_sg" {
  name       = "rds-subnets-${var.db_name}"
  subnet_ids = var.rds_private_subnet_ids

  tags = {
    Name = "rds-ubnsets-${var.db_name}"
  }
}
