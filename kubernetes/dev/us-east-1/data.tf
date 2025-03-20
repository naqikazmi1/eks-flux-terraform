data "aws_subnets" "filtered_subnets" {
  filter {
    name   = "tag:Environment"
    values = ["prod"] 
  }

  filter {
    name   = "tag:Name"
    values = ["*private*"]
  }
}

data "aws_vpc" "selected_vpc" {
  filter {
    name   = "tag:Environment"
    values = ["prod"]
  }
}

data "aws_caller_identity" "current" {}
data "aws_iam_users" "all_users" {}

data "aws_route53_zone" "zone" {
  zone_id = var.route53_zone_id
}
