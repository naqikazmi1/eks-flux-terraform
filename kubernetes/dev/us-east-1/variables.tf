variable "identifier" {
  description = "Name of the project"
  type    = string
  default = "abc"
}

variable "region" {
  description = "Name of the region"
  type    = string
  default = "us-east-1"
}

variable "env" {
  description = "Name of the environment"
  type    = string
  default = "prod"
}

variable "tags" {
  description = "Tags to be applied to the resource"
  default     = {}
  type        = map(any)
}

################################################################################
# ECR Repository
################################################################################
variable "ecr" {
  description = "List of ECR repository configurations"
  type = list(object({
    repository_name             = string
    repository_image_tag_mutability = string
    repository_encryption_type  = string
    repository_force_delete     = bool
    repository_image_scan_on_push = bool
  }))
}

################################################################################
# EKS Clusters
################################################################################
variable "eks" {
  description = "List of EKS clusters"
  type = list(object({
    cluster_name    = string
    cluster_version = string
    bootstrap_self_managed_addons = optional(bool)
    public_access = optional(bool)
    creator_perms = bool
    cluster_addons = map(object({}))
    node_security_group_additional_rules = map(object({
      description = string
      protocol    = string
      from_port   = number
      to_port     = number
      type        = string
      cidr_blocks = list(string)
    }))
    eks_role_policies = list(object({
      entity = list(string),
      policies = list(string),
      type = string
      namespaces = optional(list(string))
    })),
    eks_user_policies = list(object({
      entity = list(string),
      policies = list(string)
      type = string
      namespaces = optional(list(string))
    }))
    eks_managed_node_groups = list(object({
      node_name = string
      ami_type       = string
      instance_types = list(string)
      min_size       = number
      max_size       = number
      desired_size   = number
      iam_role_additional_policies = map(string)
    }))
  }))
}

################################################################################
# Flux CD
################################################################################
variable "key_path" {
  description = "Path to private key file for Git repository"
  type = string
}

variable "repo_url" {
  description = "Git repository URL for Flux bootstrap"
  type = string
}

variable "repo_branch" {
  description = "Git repository branch for Flux bootstrap"
  type = string
}

variable "kube_config_path" {
  description = "Path to cluster Kube-config"
  type = string
}
variable "route53_zone_id" {
  description = "Route 53 zone id"
  type = string
  default = ""  # Update with your own Route53 Zone ID
}
