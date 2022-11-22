# Self Hosted

This projects describes how to setup a self-hosted instance of R2devops.

You can check the complete documentation here 

## Usage

Customize variables according to your needs in the file <name>.env :
  ```bash
  export TF_VAR_project_name="r2devops"
  ``` 

Finally, launch the project with :

```bash
docker-compose up -d --env-file <name>.env
```