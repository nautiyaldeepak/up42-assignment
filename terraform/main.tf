resource "helm_release" "minio" {
  name       = "minio"
  chart      = "../helm-charts/minio"

  values = [
    file("${local.values_file.minio}")
  ]
}

resource "helm_release" "s3www" {
  name       = "s3www"
  chart      = "../helm-charts/s3www"

  values = [
    file("${local.values_file.s3www}")
  ]
}

resource "helm_release" "prometheus-operator" {
  name       = "prometheus-operator"
  chart      = "../helm-charts/prometheus-operator"
  namespace  = "monitoring"
  create_namespace  = "true"

  values = [
    file("${local.values_file.prometheus_operator}")
  ]
}