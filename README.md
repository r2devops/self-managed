# Self-Hosted R2Devops

This projects contains resources to setup a self-hosted instance of [R2Devops](https://r2devops.io/).

### GitLab authentication

To setup OIDC (OpenID Connect), you need to be an administrator of a Group in a Gitlab instance (on [gitlab.com](https://gitlab.com/) for instance).

See the [documentation](https://docs.r2devops.io/self-hosted/installation/#gitlab-oidc).

### R2Devops images

## Installation

### Docker compose

* Clone this repository
* Create `.env` file from `.env.example`
* Create `.docker/r2devops/config.json` file from `.docker/r2devops/config.json.example`
* Login to the container registry

```bash
echo $REGISTRY_TOKEN | docker login --username r2devops --password-stdin https://registry.gitlab.com/v2/r2devops
```

* Use Docker compose to manage the containers

```bash
docker compose up
```

### Kubernetes with Helm

Use the [Chart](charts/r2devops/README.md).

## Operations

Back & restore can be done with the bash files in `scripts` folder.
