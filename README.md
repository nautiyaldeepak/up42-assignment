up42 Assignment
===============

Serve gif present in a minio bucket.

> [s3www](https://github.com/harshavardhana/s3www) microservice will service gif stored in [Minio](https://min.io/docs/minio/container/index.html) bucket by keeping the bucket private.

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
- Both `s3www` & `minio` have hpa deployed & are using custom metrics for scaling.
- We have a 3rd helm chart which is deploying monitoring resources & config. Via this chart we're deploying `prometheus-operator` & `prometheus-adapter`. Prometheus-operator has scrape-config which is going to scrape minio metrics from `/minio/v2/metrics/*` endpoint. Then we're using prometheus-adapter to transform specific prometheus metrics for hpa scaling.
- We'll be using `terraform` templates to deploy our helm charts. 
- The `terraform` is just being used for deploying our helm-charts, all the necessary configuration is in the values file of the helm-charts.

## Deploy
> [!IMPORTANT]
> The `s3www` image is only available for `amd64` CPU type architecture. If your system's CPU architecture is `arm64`, in that case the `s3www` container will fail. Either deploy this on amd64 setup or you need to locally build s3www `docker image` and then use it.
Starting fresh minikube with 2 nodes
```
minikube delete && minikube start --nodes=2
```

Appling terraform templates
> [!NOTE]
> [1] Make sure to run the `minikube tunnel` command in a seperate terminal. We'll need it to create LoadBalancer for our service.\
> [2] Also make sure that you `kubeconfig` is in this path - `~/.kube/config`. If not then you need to change the `config_path` in `terraform/provider.tf`.
```
cd terraform
terraform init
terraform plan
terraform apply
```
> [!NOTE]
> After applying our terraform templates, the terminal in which you ran `minikube tunnel` command might ask for password.

Once the resources are deployed. You can use LoadBalancer to access the web.
Use the `s3www-service` LoadBalancer.
```
kubectl get svc
```
> [!TIP]
> The HPA metrics can take sometime to show up.

## Cleanup
Remove all the resources deployed by the stack.
```
terraform destroy
minikube delete
```

## Troubleshooting
> NOTE: This is the list of issue that you could encounter
- s3-www service launch issue
    ```
    exec /s3www: exec format error
    ```
    This is a CPU architecture issue. s3www only has image for ard64 CPU architecture. You are probably using ARM based architecture.
    Either launch the stack on AMD based CPU architecture or build the [s3www](https://github.com/harshavardhana/s3www) image locally.  
- Backend Initilization Issue
    ```
    Error: Unable to initialize backend: Storage resources are insufficient for the write operation .minio.sys/pool.bin, retrying in 570.747571ms (*fmt.wrapError)
        6: internal/logger/logger.go:243:logger.LogIf()
        5: cmd/erasure-server-pool.go:192:cmd.newErasureServerPools()
        4: cmd/server-main.go:1059:cmd.newObjectLayer()
        3: cmd/server-main.go:799:cmd.serverMain.func10()
        2: cmd/server-main.go:498:cmd.bootstrapTrace()
        1: cmd/server-main.go:797:cmd.serverMain()
    ```
    This is a stale disk information issue, so usually reboot will fix the problem.
    Start a fresh minikube cluster. Use the minikube command above.
