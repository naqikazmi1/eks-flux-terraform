locals {
  identifier = "${var.env}-${var.identifier}-${var.region}"
  azs        = slice(data.aws_availability_zones.primary.names, 0, var.number_of_az)
  tags       = merge({ Terraform = "true" }, var.tags)

  num_private_subnets = length(local.azs)
  num_public_subnets  = length(local.azs)
}