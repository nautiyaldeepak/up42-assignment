locals {
    values_file = {
        minio = "../helm-charts/minio/values-prod.yaml"
        s3www = "../helm-charts/s3www/values-prod.yaml"
        prometheus_operator = "../helm-charts/prometheus-operator/values-prod.yaml"
    }
}