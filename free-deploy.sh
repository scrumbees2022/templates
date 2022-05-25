#!/usr/bin/env bash

TOKEN=$1
#RG=$(az group list --query [].name -o tsv)

RG="webapps"
LOC="westus"

ASP="AppServicePlan"
SKU="F1"

# stroke app parameters:
APP_NAME="scrumbees-stroke-prediction"
APP_REPO="https://github.com/scrumbees2022/strokeprediction"
APP_BRANCH="main"

az group create --name $RG --location $LOC

az deployment group create \
--resource-group $RG \
--parameters @staticweb-parameters.json \
--parameters repositoryToken=$TOKEN \
--template-file "staticweb-template.json"

# deploy container.
CONTAINER_NAME="scrumbees-stroke-container"
CONTAINER_IMAGE="sebusch/stroke-prediction:latest"
# 1. Create appservice plan
az appservice plan create --name $ASP --resource-group $RG --sku $SKU --is-linux

# 2. Create webapp from docker hub
az webapp create --resource-group $RG --plan $ASP \
--name $CONTAINER_NAME \
-i $CONTAINER_IMAGE

# 3. Configure webapp to listen on correct port
az webapp config appsettings set --resource-group $RG \
--name $CONTAINER_NAME --settings WEBSITES_PORT=5000

# 4. Turn on CD -- it doesn't actually make the webhook for you
az webapp deployment container config --enable-cd true \
--name $CONTAINER_NAME --resource-group $RG \
--query CI_CD_URL --output tsv > webhook_url.txt
# This above command will output a URL which I need to paste into my docker repo


# deploy to python web app.
az deployment group create \
--resource-group $RG \
--parameters @azuredeploy.parameters.json \
--parameters appServicePlanPortalName=$ASP sku=$SKU \
--parameters webAppName=$APP_NAME repoUrl=$APP_REPO branch=$APP_BRANCH \
--template-file "azuredeploy.json"

# Configure to CI/CD github actions
# again not perfect way.
az webapp deployment source config --name $APP_NAME \
--resource-group $RG --repo-url $APP_REPO \
--branch $APP_BRANCH --git-token $TOKEN

# not perfect solution, but modity this deployment to add github actions.
# required parameters: github repo, webapp name.
# az webapp deployment github-actions add --repo "scrumbees2022/strokeprediction" \
# -g $RG -n scrumbees-stroke-prediction --token $TOKEN

echo "Webhook URL for Docker Hub repo:"
cat webhook_url.txt