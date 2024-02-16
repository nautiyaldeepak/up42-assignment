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

resource "helm_release" "prometheus-operator" {
  name       = "prometheus-operator"
  chart      = "../helm-charts/prometheus-operator"
  namespace  = "monitoring"
}