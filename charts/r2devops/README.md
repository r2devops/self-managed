# Helm chart for R2Devops

This Helm chart will install [R2Devops](https://r2devops.io/) on a Kubernetes cluster.

## Quickstart

```bash
# helm repo add #### TODO

# installs with default parameters
helm upgrade --install r2devops ####/r2devops --create-namespace \
  --namespace r2devops

# checks all pods are running after some time
kubectl get pod -n r2devops
```

## Going further

* [Contributing](CONTIBUTING.md)
