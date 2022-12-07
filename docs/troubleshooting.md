# Troubleshooting

Something terrible happens ? The application is not working as expected ?
You're at the right place !

Here are the common errors and how to solve them :

??? failure "CI/CD Catalog page load infinitely"
    This error occurs when the frontend application make a request to the backend but never get a response.
    It is a misconfiguration of the frontend Docker image for your instance.   
    Please write a mail to [tech@r2devops.io](mailto:tech@r2devops.io) and explain him the problem.

??? failure "The 'Get Started' page can't be accessed"
    It is an issue from the identity provider: [Ory Kratos](https://www.ory.sh/kratos/). You can check the logs of the faulty container with
    ```bash
    docker compose logs self-hosted-kratos-1
    ``` 
    If you have an error like this one, try to performs operations as non-root user, as described on this //TODO Add Link [section]() and ensure everything works :

    ```
    time=2022-11-23T09:41:45Z level=fatal msg=Unable to instantiate configuration. 
    audience=application error=map[message:open /etc/config/kratos/kratos.yml: permission denied] 
    service_name=Ory Kratos service_version=v0.8.0-alpha.3
    ```

    Otherwise send a mail to [tech@r2devops.io](mailto:tech@r2devops.io), explaining the problem.

??? failure "Redirect URI Invalid error in GitLab"
    This errors occurs when the Redirect URL set for your GitLab application doesn't correspond to the API_URL.
    Please, ensure you write the correct url as describe on the [section OIDC](/configuration-oidc/#create-an-application) 

---

!!! question "Don't find what you're looking for ?"
    You can directly open an issue on the [repository](https://gitlab.com/r2devops/self-hosted) or write a mail to [tech@r2devops.io](mailto:tech@r2devops.io)


//TODO - add more troubleshooting tips