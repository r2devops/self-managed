# Self-hosted R2Devops documentation


This documentation will describe you with simple steps how to self-host your own R2Devops instance 🤖.

???+ important "Before starting"
    In order to have a functional instance of R2Devops, some customization of the frontend applications are needed on our side before you can deploy it.  

    👉 To do so, you need to tell us which domain name you will use for the application.  

    📔 Please check the section about [Domain name](/configuration-domain/#about-records) to fully understand our needs.

    📨 Then write a mail to [tech@r2devops.io](mailto:tech@r2devops.io) specifying them.


???+ note "What you will need from us for the setup"
     When you send us the domain name you will use, we will provide you the following :
     
     - `REPOSITORY_TOKEN` : a token to access the repository
     - `REGISTRY_TOKEN` : a token to authenticate to our private registry
     - `FRONTEND_IMAGE_TAG` : a specific tag for the frontend image

     Keep those information safe, you will need them later.

     ⚠️ **Important** : We won"t save the tokens, so please keep them private and in a safer place.


**Summary:**

1. [Requirements](/requirements)
2. [Configuration](/configuration-app)
3. [Customization](/customization)
4. [Troubleshooting](/troubleshooting)

!!! question "Don't find what you're looking for ?"
    You can directly open an issue on the [repository](https://gitlab.com/r2devops/self-hosted) or write a mail to [tech@r2devops.io](mailto:tech@r2devops.io)


