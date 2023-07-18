# Helm chart for R2Devops

This Helm chart will install [R2Devops](https://r2devops.io/) on a Kubernetes cluster.

## Configuration

Running the chart requires configuration. See
[documentation](https://docs.r2devops.io/self-managed/kubernetes) for the
complete configuration and installation process

## Quickstart

```bash

# Create a namespace for r2devops
kubectl create ns r2devops

# Create a secret for the registry (ref. https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/)
kubectl create secret docker-registry r2devops-registry --docker-server=registry.gitlab.com/r2devops --docker-username=r2devops-user --docker-password=<TOKEN> -n r2devops

# Add the repo
helm repo add r2devops https://charts.r2devops.io/

# Install the chart
helm upgrade -n $R2DEVOPS_NS --install r2devops r2devops/r2devops -f custom_values.yaml

# Checks all pods are running after some time
kubectl get pod -n r2devops
```

## Components

R2Devops relies on the following components:

* [Kratos](https://www.ory.sh/kratos/)
* [MinIO](https://min.io/)
* [Redis](https://redis.io/)
* [PostgreSQL](https://www.postgresql.org/)

## Going further

* [Contributing](CONTIBUTING.md)
