resource "aws_launch_template" "lt" {
  name_prefix   = "${var.service_name}-${var.vpc_name}-LT"
  instance_type = "t3.medium"
  key_name      = var.key_name

}
