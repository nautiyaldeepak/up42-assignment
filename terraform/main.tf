resource "helm_release" "minio" {
  name       = "minio"
  chart      = "../helm-charts/minio"

  values = [
    "${file("../helm-charts/minio/values-prod.yaml")}"
  ]
}

resource "helm_release" "s3www" {
  name       = "s3www"
  chart      = "../helm-charts/s3www"

  values = [
    "${file("../helm-charts/s3www/values-prod.yaml")}"
  ]
}

resource "helm_release" "prometheus-operator" {
  name       = "prometheus-operator"
  chart      = "../helm-charts/prometheus-operator"
  namespace  = "monitoring"
  create_namespace  = "true"

  values = [
    "${file("../helm-charts/prometheus-operator/values-prod.yaml")}"
  ]
}