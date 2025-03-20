variable "aws_account_id" {
  type        = string
  description = "AWS account ID"
}

variable "aws_account_region" {
  type        = string
  description = "AWS region"
}

variable "eks_cluster_environment" {
  type        = string
  description = "EKS cluster environment"
}

variable "eks_cluster_identifier" {
  type        = string
  description = "EKS cluster identifier"
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "hosted_zone_id" {
  type        = string
  description = "Route 53 Hosted Zone Id"
}

variable "hosted_zone_domain_name" {
  type        = string
  description = "Route 53 Hosted Zone Namee"
}

variable "repo_url" {
  type        = string
  description = "Git repository URL for Flux bootstrap"
}

variable "repo_branch" {
  type        = string
  description = "Git repository branch for Flux bootstrap"
}

variable "key_path" {
  type        = string
  description = "Path to private key file for Git repository"
}

variable "kube_config_path" {
  type = string
  description = "Path to cluster Kube-config"
}

variable "index" {
  type = any
  description = "A list of numeric indexes used to calculate the delay duration for each iteration."
}