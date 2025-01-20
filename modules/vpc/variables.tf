variable "cidr_block" {
  description = "The cidr block of vpc"
}

variable "vpc_name" {
  description = "The name of vpc"
}

variable "nat_security_group_name" {
  description = "The name of security group in nat instance"
}

variable "subnets" {
  type = map(object({
    availability_zone  = string
    cidr_block         = string
    nat_gateway_subnet = optional(string)
  }))
}

variable "security_groups" {
  description = "Map of security groups with rules"

  type = map(object({}))

}

variable "ingress_rules" {
  type = map(object({
    security_group_name = string
    cidr_ipv4           = string
    from_port           = optional(number)
    ip_protocol         = string
    to_port             = optional(number)
  }))
}

variable "egress_rules" {
  type = map(object({
    security_group_name = string
    cidr_ipv4           = string
    from_port           = optional(number)
    ip_protocol         = string
    to_port             = optional(number)
  }))
}
