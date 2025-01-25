variable "ami_id" {
  description = "bastion ami id"
}

variable "instance_type" {
  description = "bastion instacne type"
}


variable "instance_name" {
  description = "bastion instance tag name"
}

variable "subnet_id" {
  description = "bastion instance subnet id by vpc"
}

variable "security_group_id" {
  description = "bastion instance security group id by vpc"
}

variable "keypair_name" {
  description = "bastion connection key pair name"
}

variable "availability_zone" {
  description = "Bastion host availability zone"
}

variable "ebs_volume_name" {
  description = "Bastion instance ebs volume name"
}

variable "ebs_volume_size" {
  description = "Bastion instance ebs volume size"
}

