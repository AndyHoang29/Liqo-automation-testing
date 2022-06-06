

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks-cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks-cluster.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.eks-cluster.name]
      command     = "aws"
    }
  }
}


resource "helm_release" "liqo" {
  name        = "liqo"
  chart       = "liqo"
  repository  = "./charts"
  namespace   = "liqo"
  version    = "v0.4.0"
  max_history = 3
  create_namespace = true
  wait             = true
  reset_values     = true
  # set {
  #   name  = "controller.service.type"
  #   value = "NodePort"
  # }
}