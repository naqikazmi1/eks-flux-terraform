resource "null_resource" "update_kubeconfig" {
  provisioner "local-exec" {
    command = <<-EOT
      aws eks update-kubeconfig --region ${var.aws_account_region} --name ${var.cluster_name} --kubeconfig ${var.kube_config_path}-${var.cluster_name}
    EOT
  }
}

resource "null_resource" "flux_namespace" {
  provisioner "local-exec" {
    command = <<-EOT
      kubectl create namespace flux-system --kubeconfig ${var.kube_config_path}-${var.cluster_name}
    EOT
  }
  depends_on = [null_resource.update_kubeconfig]
}

resource "null_resource" "kubeconfig" {
  provisioner "local-exec" {
    command = <<-EOT
      kubectl create configmap cluster-config-v2 --kubeconfig ${var.kube_config_path}-${var.cluster_name} \
      --from-literal=AWS_ACCOUNT_ID=${var.aws_account_id} \
      --from-literal=AWS_ACCOUNT_REGION=${var.aws_account_region} \
      --from-literal=EKS_CLUSTER_ENVIRONMENT=${var.eks_cluster_environment} \
      --from-literal=EKS_CLUSTER_IDENTIFIER=${var.eks_cluster_identifier} \
      --from-literal=ROUTE53_HOSTED_ZONE_ID=${var.hosted_zone_id} \
      --from-literal=ROUTE53_DOMAIN_NAME=${var.hosted_zone_domain_name} \
      -n flux-system
    EOT  
  }
  depends_on = [null_resource.flux_namespace]
}

resource "null_resource" "flux" {
  provisioner "local-exec" {
    command = <<-EOT
      sleep "${format("%d", var.index * 75)}"
      flux bootstrap git \
      --url=ssh://${var.repo_url} \
      --branch=${var.repo_branch} \
      --private-key-file=${var.key_path} \
      --components=source-controller,kustomize-controller,helm-controller,notification-controller \
      --components-extra=image-reflector-controller,image-automation-controller \
      --network-policy=false \
      --kubeconfig=${var.kube_config_path}-${var.cluster_name} \
      --path=clusters/base/${var.eks_cluster_environment}/${var.cluster_name} \
      --namespace=flux-system \
      --silent
    EOT
  }
  depends_on = [null_resource.kubeconfig]
}
