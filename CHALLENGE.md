Challenge
=========

## Weaknesses in the Implementation
### Secerts Management
 - In this setup we're using minio `access_key` & `secret_key`. These values are defined in values file. They are `base64` encoded, but I would not define them as secure. In an proper production setup, I would definitely use some kind of a `secrets management` service like AWS Secrets Manager, Vault or something similar.

### Minio StatefulSets
 - Scaling `minio` statefulsets is a challenge, because each service should know what all other services are running. 
 - So if we have initially deployed 2 pods which are running minio, in the args we have to mention how many minio services are there and also mention their endpoint. Once all the minio servcies discover each other only then service as a whole starts. Now if we scale this and a new minio service comes up, we have to basically tell all the existing minio services to add another endpoint and also give this new service the endpoints of existing minio services running.
 - Although, I have added scaling for minio and as the traffic increases the new pods will come up but they won't be able to join the existing cluster.

### Ephemeral Storage
 - In this setup we're using `ephemeral` storage. So if a minio pod is deleted, its data would be lost. Although, in this setup as we're running atleast 2 minio `replicas`, So even if we delete one pod, its data will be lost but after getting recreated it again is going to connect with the other running minio pod and sync its data.
 - If all the running pods are deleted then all the `data` is lost permanently.
 - In a proper production environment we'll proper persistent volumes for our pods.

## Strengths of the Implementation
 - All ther services are being managed by `helm-charts` and helm-charts are being deployed by `terraform`. This gives us an easy in deployment. 
 - All the helm charts are customizable. This means that, if we want to create a new stack on some other `kubernetes cluster` we can quickly create a new values file with desired values and deploy.
 - Horizontal `Autoscaling` is already enabled for both services. This means that as the traffic on our services increase, the services will scale on their own. 

## Things that can be done furthur
### Logging & Alerting
 - `Logging` & `Alerting` can be setup for our services. We already do have `monitoring` stack for our setup but we still need to create custom dashboards to enhance the `observability` of our services. Appling alerting for our services will help us, if there is something extraordinary with our stack.

### DNS Mapping
 - We do have a `LoadBalancer` it'll do the job for us, but mapping a `DNS` onto our loadBalancer should be the next step.
