locals {
  private_subnets = {
    for key, subnet in var.subnets :
    key => subnet
    if(lookup(subnet, "nat_gateway_subnet", null)) != null
  }

  public_subnets = {
    for key, subnet in var.subnets :
    key => subnet
    if(lookup(subnet, "nat_gateway_subnet", null)) == null
  }
}

################################################################
#                             VPC                              #
################################################################

resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

  tags = {
    Name = var.vpc_name
  }
}

################################################################
#                             IGW                              #
################################################################
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}


################################################################
#                            Subnet                            #
################################################################
resource "aws_subnet" "subnets" {
  for_each                = var.subnets
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = lookup(each.value, "nat_gateway_subnet", null) != null ? false : true

  tags = {
    Name = each.key
  }
}


################################################################
#                   Public-Route-Table                         #
################################################################
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-public-route-table"
  }
}

resource "aws_route" "public_routes" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"

  gateway_id = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public_associations" {
  for_each = local.public_subnets

  subnet_id      = aws_subnet.subnets[each.key].id
  route_table_id = aws_route_table.public_route_table.id
}



################################################################
#                             SG                               #
################################################################
resource "aws_security_group" "groups" {
  for_each = var.security_groups

  name   = each.key
  vpc_id = aws_vpc.main.id

  tags = {
    Name : each.key
  }
}

resource "aws_vpc_security_group_ingress_rule" "rules" {
  for_each = var.ingress_rules

  security_group_id = aws_security_group.groups[each.value.security_group_name].id
  cidr_ipv4         = each.value.cidr_ipv4
  from_port         = each.value.from_port
  ip_protocol       = each.value.ip_protocol
  to_port           = each.value.to_port
}

resource "aws_vpc_security_group_egress_rule" "rules" {
  for_each = var.egress_rules

  security_group_id = aws_security_group.groups[each.value.security_group_name].id
  cidr_ipv4         = each.value.cidr_ipv4
  from_port         = each.value.from_port
  ip_protocol       = each.value.ip_protocol
  to_port           = each.value.to_port
}

resource "aws_vpc_security_group_ingress_rule" "admin_rule" {
  security_group_id = aws_security_group.groups["infraworkshop-apne2-admin-permit-security-group"].id
  cidr_ipv4         = "${chomp(data.http.myip.response_body)}/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}




################################################################
#                       NAT-Instance                           #
################################################################
resource "aws_network_interface" "fck-nat-if" {
  subnet_id = aws_subnet.subnets[
    lookup(local.private_subnets[keys(local.private_subnets)[0]], "nat_gateway_subnet")
  ].id
  security_groups = [aws_security_group.groups[var.nat_security_group_name].id]

  source_dest_check = false
}

resource "aws_instance" "fck-nat" {
  ami           = data.aws_ami.fck_nat.id
  instance_type = "t3.nano"
  tags = {
    Name = "${var.vpc_name}-nat-instance"
  }

  network_interface {
    network_interface_id = aws_network_interface.fck-nat-if.id
    device_index         = 0
  }
}


################################################################
#                   Private-Route-Table                        #
################################################################
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-private-route-table"
  }
}

resource "aws_route" "private_routes" {

  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"


  network_interface_id = aws_instance.fck-nat.primary_network_interface_id
}

resource "aws_route_table_association" "private_associations" {
  for_each = local.private_subnets

  subnet_id      = aws_subnet.subnets[each.key].id
  route_table_id = aws_route_table.private_route_table.id
}
