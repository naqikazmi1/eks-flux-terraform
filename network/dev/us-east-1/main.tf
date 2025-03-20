module "vpc" {
  source = "terraform-aws-modules/eks/aws"

  name = "${local.identifier}-${var.vpc.name}"
  cidr = var.vpc.cidr
  azs = local.azs
  enable_nat_gateway     = var.vpc.enable_nat_gateway
  single_nat_gateway     = var.vpc.single_nat_gateway
  one_nat_gateway_per_az = var.vpc.one_nat_gateway_per_az
  
  private_subnets = [for i in range(0, local.num_private_subnets) : cidrsubnet(var.vpc.cidr, var.subnet_bits, i)]
  public_subnets  = [for i in range(local.num_private_subnets, local.num_private_subnets + local.num_public_subnets) : cidrsubnet(var.vpc.cidr, var.subnet_bits, i)]
  
  map_public_ip_on_launch = var.vpc.map_public_ip_on_launch

  public_subnet_names = [
    for i in range(0, length(local.azs)) : 
    "${local.identifier}-public-${element(local.azs, i)}"
  ]
  private_subnet_names = [
    for i in range(0, length(local.azs)) : 
    "${local.identifier}-private-${element(local.azs, i)}"
  ]

}
