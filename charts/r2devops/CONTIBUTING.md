# Contributing to R2Devops Helm chart

## How to update the dependencies

```bash
# adds helm chart repositories
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add minio https://charts.min.io/
helm repo add ory https://k8s.ory.sh/helm/charts
helm repo update

# searches for the latest versions
helm search repo -l kratos --versions
helm search repo -l minio --versions
helm search repo -l redis --versions
helm search repo -l postgresql --versions

# manual: update version number in Chart.yaml

# updates Chart.lock
helm dependency update
```

## How to create or update the chart

```bash
# checks code style
helm lint

# checks the Kubernetes objects generated from the chart
helm template r2devops . -f values.yaml \
  --namespace r2devops > temp.yaml
```

## How to deploy manually from the sources

### Sample with a given password

```bash
# retrieves public IP
NGINX_PUBLIC_IP=`kubectl get service -n ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

# applies the manifest (add "--debug > output.yaml" in case of issue)
helm upgrade --install r2devops . -f values.yaml --create-namespace \
  # TODO
  --namespace r2devops

# cleans up
helm uninstall r2devops -n r2devops
kubectl delete ns r2devops
```
