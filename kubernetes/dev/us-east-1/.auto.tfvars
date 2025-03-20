################################################################################
# ECR Repository
################################################################################
ecr = [
    {
        repository_name = "app"
        repository_image_tag_mutability = "MUTABLE"
        repository_encryption_type = "AES256"
        repository_force_delete = false
        repository_image_scan_on_push = true
        tags = {
            version = "1.0"
        }
    }
]
################################################################################
# EKS Clusters
################################################################################
eks = [
  {
    cluster_name    = "test"
    cluster_version = "1.29"
    creator_perms = true
    cluster_addons = {
      coredns = {}
      kube-proxy = {}
      aws-ebs-csi-driver = {
        addon_version = "v1.38.1-eksbuild.2"
      }
      eks-pod-identity-agent = {}
    }
    node_security_group_additional_rules = {
      vpc_us-west-1_allow_all = {
        description = "Node to node all ports/protocols"
        protocol    = "-1" 
        from_port   = 0
        to_port     = 0
        type        = "ingress"
        cidr_blocks = ["10.0.0.0/16"]
      }
      vpc_us-east-2_allow_all = {
        description = "Node to node all ports/protocols"
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        type        = "ingress"
        cidr_blocks = ["11.0.0.0/16"]
      }
    }
    eks_role_policies = [ 
      {
        entity = ["xyz"]
        policies = ["AmazonEKSEditPolicy"]
        type = "cluster"
      }
    ]
    eks_user_policies = [
      {
        entity = ["abc"]
        policies = ["AmazonEKSAdminPolicy","AmazonEKSClusterAdminPolicy"]
        type = "namespace"
        namespaces = ["abc"]
      }
    ]
    eks_managed_node_groups = [
      {
        node_name = "node_group"
        ami_type       = "AL2023_x86_64_STANDARD"
        instance_types = ["t3.medium"]
        min_size       = 2
        max_size       = 5
        desired_size   = 3
        iam_role_additional_policies = {
          AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
          AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
        }
      }
    ]
  }
]

################################################################################
# Flux CD
################################################################################
repo_url = "your_repo_url"
key_path = "your_ssh_key_path"
repo_branch = "your_branch"
kube_config_path = "./kube-config"
