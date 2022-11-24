# Configuration

### Install the application


???+ warning "Server and non-Root user"

    This step should be done inside your server. You can connect to your server using SSH with the following command:
    ```bash
    ssh <user>@<host>
    ```
    For permission reason perform the below commands with a **non-root user**, 👉 user should be different from `root`.

    See [Requirements](/requirements/#ssh) for more information.

Once your system meet the requirements, you need to copy the repository inside the server :

```bash
git clone https://gitlab.com/r2devops/self-hosted.git

```

Then move inside the project folder and launch the following commands : 

```bash 
cd self-hosted
chmod u+x,a+rx . -R
chmod 600 acme.json
# Generate a random secret for the cookie domains
sed -i "s/SECRETS_COOKIE_TO_CHANGE/$(openssl rand -hex 32)/g" local.env  
```

Finally change the `CERTIFICATE_EMAIL` variable with your email inside `local.env`. It will warn you if the certificate for the domain name expires.

The file should looks like this :

```bash title="local.env" hl_lines="4" 
DOMAIN_NAME="r2devops.<domain_name>"
FRONTEND_URL="$DOMAIN_NAME"
API_URL="api.$DOMAIN_NAME"
CERTIFICATE_EMAIL="<name>@<domain_name>"
SECRETS_COOKIE="..." # the random secret generated below
```