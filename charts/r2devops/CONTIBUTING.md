# Contributing to R2Devops Helm chart

In this page, you'll find command lines to help you contribute to the Helm chart.

## How to update the dependencies

```bash
# adds helm chart repositories
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add ory https://k8s.ory.sh/helm/charts
helm repo update

# searches for the latest versions
helm search repo -l [kratos|minio|redis|postgresql] --versions

# manual action: update version number in Chart.yaml

# updates Chart.lock
helm dependency update
```

## How to configure

```bash
cp examples/values_local.yaml values_mine.yaml
sed -i "s/MINIO_PASSWORD/$(openssl rand -hex 16)/g" values_mine.yaml
sed -i "s/POSTGRESQL_PASSWORD/$(openssl rand -hex 16)/g" values_mine.yaml
sed -i "s/REDIS_PASSWORD/$(openssl rand -hex 16)/g" values_mine.yaml
sed -i "s/KRATOS_SECRETS_DEFAULT/$(LC_ALL=C tr -dc '[:alnum:]' < /dev/urandom | head -c32)/g" values_mine.yaml
sed -i "s/KRATOS_SECRETS_COOKIE/$(LC_ALL=C tr -dc '[:alnum:]' < /dev/urandom | head -c32)/g" values_mine.yaml
sed -i "s/KRATOS_SECRETS_CIPHER/$(LC_ALL=C tr -dc '[:alnum:]' < /dev/urandom | head -c32)/g" values_mine.yaml
```

💡 Follow the [documentation](https://docs.r2devops.io/self-managed/kubernetes/#gitlab-oidc) to retrieve values of `GITLAB_CLIENT_ID` and `GITLAB_CLIENT_ID` in `values_mine.yaml`

## How to check chart code quality

```bash
# checks code style
helm lint

# checks the Kubernetes objects generated from the chart
helm template r2devops . -f values.yaml -f values_mine.yaml --namespace r2devops-beta > temp.yaml
```

## How to deploy manually from the sources

### Sample with all charts, NGINX Ingress controler, sslip.io, cert-manager & Let's Encrypt

```bash
# retrieves public IP
NGINX_PUBLIC_IP=`kubectl get service -n ingress-nginx ingress-nginx-controller --output jsonpath='{.status.loadBalancer.ingress[0].ip}'`

# creates the namespace
kubectl create ns r2devops-beta

# creates the container registry secret
kubectl create secret docker-registry r2devops-registry --docker-server=registry.gitlab.com/r2devops --docker-username=r2devops-user --docker-password="<r2devops_registry_token>" -n r2devops-beta

# sets the right URLs by replacing the string in values_mine.yaml
sed -i "s/R2DEVOPS_DOMAIN/r2devops.${NGINX_PUBLIC_IP}.sslip.io/g" values_mine.yaml

# applies the manifest (add "--debug > output.yaml" in case of issue)
helm install r2devops . -f values.yaml -f values_mine.yaml \
--set kratos.dependency.enabled=false \
--namespace r2devops-beta

# installs completely with kratos
helm upgrade r2devops . -f values.yaml -f values_mine.yaml --namespace r2devops-beta

# makes sure everything runs fine
kubectl get pod -n r2devops-beta

# cleans up
helm uninstall r2devops -n r2devops-beta
kubectl delete ns r2devops-beta
```

## How to investigate

```bash
# forwards PostgreSQL service (to open with pgAdmin for example)
kubectl port-forward service/r2devops-postgresql 5432:5432 -n r2devops-beta
```
