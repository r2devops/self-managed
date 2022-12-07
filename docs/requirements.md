
### Requirements

In order to self-hosted your own R2Devops instance, you need to have access to a Linux server.

You should ensure the below applications are installed on your system as well.

- [ ] [SSH](#ssh)
- [ ] [Git](#git) 
- [ ] [Docker](#docker)

If all the requirements are met, you can directly continue to the next step.

#### SSH

As some steps will be done inside your server, you should ensure you have access to it.

Most of the time, you access a server through SSH, so you can use the following command to connect to your server:

```bash
ssh <user>@<host>
```

You're in ? All right, let's move further 🧑‍💻
    

#### Git

The self-hosted repository can be directly cloned from GitLab, so ensure git is installed on your system with this command : 
```bash
git version 
```

If the following command response, you can proceed to next step 👇

Otherwise, check the installation part in the [documentation](https://git-scm.com/download/linux).

#### Docker 🐳

Docker Engine should be installed on your system, as well as Docker Compose which is used for orchestrating all services.

Ensure Docker Engine and Docker Compose are installed.

```bash
docker --version
docker-compose --version
```

If not, you can follow the official documentation to install them.

* Docker Engine: https://docs.docker.com/engine/install/
* Docker Compose: https://docs.docker.com/compose/install/

Now you should be able to run the following command:

```bash
docker run hello-world
```

which should produces the following output:

```bash
Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

Great! Let see how to install the application 👉
