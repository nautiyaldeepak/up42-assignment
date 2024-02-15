resource "helm_release" "minio" {
  name       = "minio"
  chart      = "../helm-charts/minio"
}

resource "helm_release" "s3www" {
  name       = "s3www"
  chart      = "../helm-charts/s3www"
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "kube-prometheus" {
  name       = "kube-prometheus-stack"
  namespace  = "monitoring"
  version    = "56.6.2"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
}