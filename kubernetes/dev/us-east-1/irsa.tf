module "cert-manager-irsa" {
  source  = "terraform-aws-modules/eks/aws"
  
  for_each = { for k,v in var.eks : k => v }

  role_name = "${local.identifier}-cert-manager-role"

  attach_cert_manager_policy    = true
  cert_manager_hosted_zone_arns = local.route53_zone_arn

  oidc_providers = {
    roles = {
      provider_arn = module.eks[each.value.cluster_name].oidc_provider_arn
      namespace_service_accounts = ["cert-manager:cert-manager"]
    }
  }

  tags = local.tags
}

module "external-dns-irsa-role" {
  source  = "terraform-aws-modules/eks/aws"
  
  for_each = { for k,v in var.eks : k => v }

  role_name = "${local.identifier}-external-dns-role"

  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = local.route53_zone_arn

  oidc_providers = {
    roles = {
      provider_arn = module.eks[each.value.cluster_name].oidc_provider_arn
      namespace_service_accounts = ["external-dns:external-dns"]
    }
  }

  tags = local.tags
}
