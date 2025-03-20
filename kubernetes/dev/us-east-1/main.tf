################################################################################
# ECR Rrpository
################################################################################
module "ecr" {
  source = "terraform-aws-modules/eks/aws"

  for_each = { for repo in var.ecr : repo.repository_name => repo }

  repository_name               = "${local.identifier}-${each.value.repository_name}"
  repository_image_tag_mutability = each.value.repository_image_tag_mutability
  repository_encryption_type    = each.value.repository_encryption_type
  repository_force_delete       = each.value.repository_force_delete
  repository_image_scan_on_push = each.value.repository_image_scan_on_push
}

################################################################################
# EKS Cluster
################################################################################
module "eks" {
  source  = "terraform-aws-modules/eks/aws"

  for_each = { for cluster in var.eks : cluster.cluster_name => cluster }

  cluster_name    = "${local.identifier}%{ if each.value.cluster_name != "" }-${each.value.cluster_name}%{ else }%{ endif }"
  cluster_version = each.value.cluster_version

  bootstrap_self_managed_addons = each.value.bootstrap_self_managed_addons
  cluster_addons = each.value.cluster_addons

  cluster_endpoint_public_access = each.value.public_access
  enable_cluster_creator_admin_permissions = each.value.creator_perms
  node_security_group_additional_rules = each.value.node_security_group_additional_rules
  access_entries = merge(
    {
      for entry in local.user_policies[each.value.cluster_name] : format("%s-%s", entry.entity_name, join("-", keys(entry.policy_associations))) => {
      principal_arn = entry.entity_arn
      policy_associations = {
        for policy_name, details in entry.policy_associations : policy_name => {
          policy_arn   = details.policy_arn
          access_scope = {
            type       = details.policy_type
            namespaces = details.namespaces
          }
        }
      }
    }
  },
    {
      for entry in local.role_policies[each.value.cluster_name] : format("%s-%s", entry.entity_name, join("-", keys(entry.policy_associations))) => {
        principal_arn = entry.entity_arn
        policy_associations = {
          for policy_name, details in entry.policy_associations : policy_name => {
            policy_arn   = details.policy_arn
            access_scope = {
              type       = details.policy_type
              namespaces = details.namespaces
            }
          }
        }
      }
    }
  )
  vpc_id = local.vpc_id
  subnet_ids = local.selected_subnets
  control_plane_subnet_ids = local.selected_subnets

  eks_managed_node_groups = [
    for node in each.value.eks_managed_node_groups : {
      name = node.node_name
      name_prefix = local.identifier
      ami_type       = node.ami_type
      instance_types = node.instance_types
      min_size       = node.min_size
      max_size       = node.max_size
      desired_size   = node.desired_size
      iam_role_additional_policies = lookup(node, "iam_role_additional_policies", [])
    }
  ]
}

################################################################################
# Flux CD
###############################################################################
module "eks_config" {
  source = "./modules/cluster_configs"
  for_each = { for cluster in local.cluster_list: cluster.cluster_name => cluster }

  aws_account_id          = local.account_id
  aws_account_region      = var.region
  eks_cluster_environment = var.env
  eks_cluster_identifier  = var.identifier
  hosted_zone_id          = var.route53_zone_id
  hosted_zone_domain_name = data.aws_route53_zone.zone.name
  cluster_name            = each.key
  repo_url                = var.repo_url
  repo_branch             = var.repo_branch
  key_path                = var.key_path
  kube_config_path = var.kube_config_path
  index = index(local.cluster_list, each.value)
  depends_on = [ module.eks ]
}
