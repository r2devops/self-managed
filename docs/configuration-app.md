# Configuration

### Install the application


???+ warning "Non-Root user"
    For permission reason perform the below commands with a **non-root user**, 👉 user should be different from `root`.


#### Clone the repository 

Once your system meet the requirements, you need to copy the repository inside the server :

```bash
git clone https://r2devops:<REPOSITORY_TOKEN>gitlab.com/r2devops/self-hosted.git

```

??? important "REPOSITORY_TOKEN"
    You can find the `REPOSITORY_TOKEN` in the mail we sent you.

??? failure "I get a `git clone` error"
    Make sure you are pasting the right token!

    Otherwise write a mail to [tech@r2devops.io](mailto:tech@r2devops.io) and ask him a `read_repository` token for self-hosted



#### Set permissions and variables

Then launch the following commands : 

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