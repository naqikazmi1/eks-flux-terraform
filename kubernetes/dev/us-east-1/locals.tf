locals {
  identifier = "${var.env}-${var.identifier}-${var.region}"

  route53_zone_arn = ["arn:aws:route53:::hostedzone/${var.route53_zone_id}"]

  tags = merge({ Terraform = "true" }, var.tags)

    subnet_map = {
    for idx, id in data.aws_subnets.filtered_subnets.ids :
    "subnet_${idx}" => id
  }

  selected_subnets = [
    lookup(local.subnet_map, "subnet_0", null),
    lookup(local.subnet_map, "subnet_1", null)
  ] 

  vpc_id = data.aws_vpc.selected_vpc.id

  role_policies = { 
    for cluster in var.eks: cluster.cluster_name => flatten([
      for role_policy in cluster.eks_role_policies : [
        for role in role_policy.entity : {
          entity_name = role
          entity_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${role}"
          policy_associations = { for policy in role_policy.policies : policy => {
            policy_name = policy
            policy_type = role_policy.type
            policy_arn = "arn:aws:eks::aws:cluster-access-policy/${policy}"
            namespaces = role_policy.namespaces
            }
          }
        }
      ]
    ])
  }


  user_policies = {
    for cluster in var.eks : cluster.cluster_name => flatten([
      for user_policy in cluster.eks_user_policies : [
        for user in user_policy.entity : {
          entity_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${user}"
          entity_name = user
          policy_associations = {
            for policy in user_policy.policies : policy => {
              policy_name = policy
              policy_type = user_policy.type
              policy_arn  = "arn:aws:eks::aws:cluster-access-policy/${policy}"
              namespaces  = user_policy.namespaces
            }
          }
        }
      ]
    ])
  }

  account_id = data.aws_caller_identity.current.account_id
  cluster_list = [for key, value in module.eks: {
    cluster_name = value.cluster_name
  }]
}
