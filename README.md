up42 Assignment
===============

Serve gif present in a minio bucket.

> s3www microservice will service gif stored in [Minio](https://min.io/docs/minio/container/index.html) bucket by keeping the bucket private.

## Pre-requisites
- [docker](https://docs.docker.com/engine/install/)
- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [minikube](https://minikube.sigs.k8s.io/docs/start/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
- [helm](https://helm.sh/docs/intro/install/)
- [terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

## Overview

- There are 2 helm-charts `minio` & `s3www`. Minio helm-chart will deploy a deployment & a job & s3www helm-chart will be deploying the s3www-server deployment.
- For `minio` helm-chart, the deployment is a minio-server which is going to emulate the behaviour of s3 and the job is running a script which is going to download the gif and copy it in the minio bucket.
- s3www-server is going to server the file stored in the s3 bucket.
- We'll be using `terraform` templates to deploy our helm charts. 
- The `terraform` is just being used for deploying our helm-charts, all the necessary configuration is in the values file of the helm-charts.

## Deploy
Starting minikube
```
minikube start
```

Appling terraform templates
> NOTE: Make sure to run the `minikube tunnel` command in a seperate terminal. We'll need it to create LoadBalancer for our service.
```
cd terraform
terraform init
terraform plan
terraform apply
```
> NOTE: After applying our terraform templates, the terminal in which you ran `minikube tunnel` command might ask for password.