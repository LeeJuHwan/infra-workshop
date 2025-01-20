output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnets" {
  value = aws_subnet.subnets
}

output "security_groups" {
  value = aws_security_group.groups
}
