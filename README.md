## How to use this repo in the cloud shell to deploy our webapps:

This script is for use in the sandbox, because the .sh files use a command there
which assumes there is only one resource group and that you want to deploy into it.

1. Activate the bash cloud shell and create the storage that is needed to do that.
2. Clone this git repo into it:
```bash 
$ git clone https://github.com/scrumbees2022/templates
```
3. change to the templates directory:
```bash
$ cd templates
```
4. Select your script file: if you are in the sandbox, your script file is `free-deploy.sh`, and if you're not in a sandbox, `free-deploy-non-sb.sh` will create and use a resource group for this set of resources. I'll use the non-sandbox version below:
5. Deploy all our apps and app service plan. -- This requires a github personal access token, which you can create in your own account or get from SarahB (normally we would put it in Azure Key Vault.), replace TOKEN by that value below:
```bash
$ ./free-deploy-non-sb.sh TOKEN
```
6. The final step is to give SarahB the Dockerhub webhook URL which is the final output of this script. Putting that in the dockerhub repo will enable the CD webhook.


7. Your final results:

    1. Static web app: find the URL by going to the resource.
    2. App Service Plan (Free tier)
    2. Container app deployed through Docker Hub and CD enabled (if the webhook was provided to SarahB)
    3. Python web app with github actions enabling CI/CD.

8. Clean up: If storage is charged for, you might want to remove the cloudshell storage account.

---
## Below here is old version for how to deploy.
4. Deploy the static web app -- This requires a token from SarahB (normally we would put it in Azure Key Vault.), replace TOKEN by that value below:
```bash
$ ./staticweb-deploy.sh TOKEN
```
5. Deploy the stroke webapp -- This current script doesn't make it auto-update on github update, it just copies it once during deployment. (TODO: update to make it auto-update) Also, the webapp must have a unique name, so if that's causing it to fail, change the webAppName value in `azuredeploy.parameters.json`
```bash
$ ./script.sh
```


TODO:
1. Combine into one template for simultaneous deployment
2. Ensure the webapp has github actions available
3. Do the deployment for database.