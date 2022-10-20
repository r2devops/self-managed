# Self Hosted

This projects aims to provides infrastructure files in order to launch a self hosted instance of [R2Devops](https://r2devops.io).

## Usage

Customize variables according to your needs in the file <name>.env :
  ```bash
  export TF_VAR_project_name="r2devops"
  ``` 

Finally, launch the project with :

```bash
docker-compose up -d --env-file <name>.env
```