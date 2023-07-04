# Contributing to R2Devops Helm chart

## How to update the dependencies

```bash
# adds helm chart repositories
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add minio https://charts.min.io/
helm repo add ory https://k8s.ory.sh/helm/charts
helm repo update

# searches for the latest versions
helm search repo -l [kratos|minio|redis|postgresql] --versions

# manual: update version number in Chart.yaml

# updates Chart.lock
helm dependency update
```

## How to check chart code quality

```bash
# checks code style
helm lint

# checks the Kubernetes objects generated from the chart
helm template r2devops . -f values.yaml \
  --set minio.dependency.enabled=true \
  --set postgresql.dependency.enabled=true \
  --set redis.dependency.enabled=true \
  --namespace r2devops > temp.yaml
```

## How to deploy manually from the sources

### Sample with all charts

```bash
# retrieves public IP
NGINX_PUBLIC_IP=`kubectl get service -n ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

# applies the manifest (add "--debug > output.yaml" in case of issue)
helm upgrade --install r2devops . -f values.yaml --create-namespace \
  --set front.host=r2devops.${NGINX_PUBLIC_IP}.sslip.io \
  --set jobs.host=api.r2devops.${NGINX_PUBLIC_IP}.sslip.io \
  --set ingress.enabled=true \
  --set ingress.className=nginx \
  --set ingress.annotations.'cert-manager\.io/cluster-issuer'=letsencrypt-prod \
  --set kratos.dependency.enabled=false \
  --set minio.dependency.enabled=true \
  --set postgresql.dependency.enabled=true \
  --set redis.dependency.enabled=true \
  --namespace r2devops \
  --debug

# cleans up
helm uninstall r2devops -n r2devops
kubectl delete ns r2devops
```

## How to investigate

```bash
# forwards PostgreSQL service (to open with pgAdmin for example)
kubectl port-forward service/r2devops-postgresql 5432:5432 -n r2devops
```
