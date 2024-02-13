# Helm chart for R2Devops

This Helm chart will install [R2Devops](https://r2devops.io/) on a Kubernetes cluster.

💡 See the [documentation](https://docs.r2devops.io/self-managed/kubernetes) for the complete configuration and installation process.

## Quickstart

### Configuration

Create a `custom_values.yaml` file with your values.

### Operations

Run the following command lines from a terminal:

```bash
# sets Kubernetes namespace name
export R2DEVOPS_NS="r2devops"

# creates a namespace for r2devops
kubectl create ns $R2DEVOPS_NS

# adds R2Devops Helm repository
helm repo add r2devops https://charts.r2devops.io/

# upgrades R2Devops chart
helm upgrade --install -n $R2DEVOPS_NS r2devops r2devops/r2devops -f custom_values.yaml

# checks all pods are running after some time
kubectl get pod -n $R2DEVOPS_NS
```

## Going further

* [Contributing](CONTIBUTING.md) to this Helm chart
