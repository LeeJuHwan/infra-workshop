variable "db_name" {
  description = "rds database name"
}

variable "username" {
  description = "rds username"
  type        = string
  sensitive   = true
}

variable "password" {
  description = "rds password"
  type        = string
  sensitive   = true
}

variable "db_engine" {
  description = "Database engine (e.g mysql, postgres)"
  type        = string
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "RDS access security gorup id list"
  type        = list(string)

}

variable "rds_private_subnet_ids" {
  description = "RDS access subnets only private zone"
  type        = list(string)
}
