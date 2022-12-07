
# Configuration

Final steps : login to docker and ensure it is working !

### Docker Pull

It's time to ensure, you have the correct access rights to pull the frontend image.

First change the `FRONTEND_IMAGE_TAG` uses by the frontend service :

```yaml title="docker-compose.yml" hl_lines="2"
  frontend:
    image: registry.gitlab.com/r2devops/frontend:$FRONTEND_IMAGE_TAG
```

Then paste this command : 
```bash
docker login https://registry.gitlab.com/v2/r2devops
```

With the below information:

- username: `r2devops`
- password: `REGISTRY_TOKEN`


??? info "Where should I find them ?"
    `REGISTRY_TOKEN` and `FRONTEND_IMAGE_TAG` have been send to you by email at the [beginning](/).  

### Launch the application


!!! success "Congratulations"
    You have successfully installed R2Devops on your server 🎉  
    Now you can launch the application and ensure everything works as expected.

Go inside the folder `self-hosted` and launch the following command :
```bash
docker compose --env-file=local.env up -d
```
??? failure "I get a `docker compose` error"
    Make sure you are pasting the right token!

    Otherwise write a mail to [tech@r2devops.io](mailto:tech@r2devops.io) and ask him a `read_registry` token for the frontend


The terminal will start all services, you can ensure that they are all running :

```
$ docker ps
CONTAINER ID   IMAGE                                                                            COMMAND                  CREATED          STATUS                  PORTS                                      NAMES
1b879e010f1e   traefik:v2.9                                                                     "/entrypoint.sh --en…"   10 seconds ago   Up 4 seconds            0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp   self-hosted-traefik-1
b8cd8edf7a12   oryd/kratos:v0.8.0-alpha.3-sqlite                                                "kratos serve -c /et…"   11 seconds ago   Up Less than a second   4433-4434/tcp                              self-hosted-kratos-1
f91acf9e069e   registry.gitlab.com/r2devops/jobs:10ce311e2459f27edc09f87a51ca4aec071b6300       "/bin/sh -c 'sleep 1…"   11 seconds ago   Up 6 seconds                                                       self-hosted-jobs_worker-1
748ed298cc84   registry.gitlab.com/r2devops/jobs:10ce311e2459f27edc09f87a51ca4aec071b6300       "/bin/sh -c 'sleep 1…"   11 seconds ago   Up 6 seconds            80/tcp                                     self-hosted-jobs-1
caffdb9c6640   registry.gitlab.com/r2devops/frontend:3e0c2aeed4bad178ddbf8b2e1e4eccaab6f926bd   "/docker-entrypoint.…"   13 seconds ago   Up 8 seconds            80/tcp, 3000/tcp                           self-hosted-frontend-1
e6b1d58e8784   redis:6                                                                          "docker-entrypoint.s…"   13 seconds ago   Up 8 seconds            6379/tcp                                   self-hosted-redis-1
ac976f9acb27   mailhog/mailhog:latest                                                           "MailHog"                13 seconds ago   Up 8 seconds            1025/tcp, 8025/tcp                         self-hosted-mailhog-1
72ac3ad6e550   postgres:13                                                                      "docker-entrypoint.s…"   13 seconds ago   Up 8 seconds            5432/tcp                                   self-hosted-postgres-1
```


You can now proceed to final checks !

### Checks

Here is a quick gif showing actions to realize to ensure the application is working as excepted :

![Final steps](images/final_steps.gif)

*The GIF showing the steps to ensure everything is working*

### Detailed steps : 

This is the last step, to ensure your R2Devops instance is fully configured.

Open your browser and go to the `FRONTEND_URL` you have set in the `local.env` file.

Open `Get started` to create your account and click with on `Continue with GitLab`. 

Authorize the application to access your GitLab account.

You should directly be redirected to the website.

The application will then ask for a GitLab Token with `read_api` scope.

Go to your GitLab profile, then go to `Settings > Access Tokens` and click on `Create personal access token`.

Then paste the token in the form and click and submit.

You should now be able to use R2Devops ! Check if you have your organization in the `Organization` menu.

!!! note "What's next"
    Now that you have finished this tutorial, here are some simple tasks you should give a try :
    📕 Import your first job, here is the [tutorial](https://docs.r2devops.io/get-started-link-job/)
    📈 Learn how to use the platform by reading the [documentation](https://docs.r2devops.io)  
    ⭐ If you like the project, don't hesitate to give a start to r2devops project !  

!!! error "Not the same behavior"
    You encountered a problem during the installation process ? Please see the [troubleshooting](/troubleshooting/#trouvleshooting) section.