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