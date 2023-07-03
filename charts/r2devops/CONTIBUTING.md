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

### Create a secret for the registry

```bash
kubectl create ns r2devops
kubectl create secret docker-registry regcred --docker-server=<r2devops-registry-server> --docker-username=<username> --docker-password=<token> -n r2devops
```

### Sample with all charts

```bash
# retrieves public IP
NGINX_PUBLIC_IP=`kubectl get service -n ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

# TODO: set release name and replace in the command line (and review values.yaml), do the same for the secret name (regcred)

# applies the manifest (add "--debug > output.yaml" in case of issue)
helm upgrade --install r2devops . -f values.yaml --create-namespace \
  --set front.host=r2devops.${NGINX_PUBLIC_IP}.sslip.io,front.tls.secretName=r2devops-front-tls \
  --set jobs.host=r2devops-jobs.${NGINX_PUBLIC_IP}.sslip.io,jobs.tls.secretName=r2devops-jobs-tls \
  --set ingress.enabled=true,ingress.className=nginx,ingress.annotations.'cert-manager\.io/cluster-issuer'=letsencrypt-prod \
  --set kratos.dependency.enabled=false \
  --set minio.dependency.enabled=true,minio.custom.host=r2devops-minio \
  --set postgresql.dependency.enabled=true,postgresql.custom.host=r2devops-postgresql \
  --set redis.dependency.enabled=true,redis.custom.host=r2devops-redis-master \
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
