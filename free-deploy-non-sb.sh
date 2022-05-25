#!/usr/bin/env bash

TOKEN=$1
#RG=$(az group list --query [].name -o tsv)

RG="webapps"
LOC="westus"

ASP="AppServicePlan"
SKU="F1"

# python app deployment parameters:
APP_NAME="scrumbees-diabetes-prediction"
APP_REPO="https://github.com/scrumbees2022/diabetesprediction"
APP_BRANCH="master"

# container app deployment parameters:
CONTAINER_NAME="scrumbees-stroke-prediction"
CONTAINER_IMAGE="sebusch/stroke-prediction:latest"


# Create a resource group
az group create --name $RG --location $LOC

# deploy static portal page
az deployment group create \
--resource-group $RG \
--parameters @staticweb-parameters.json \
--parameters repositoryToken=$TOKEN \
--template-file "staticweb-template.json"


# deploy python web app using template
az deployment group create \
--resource-group $RG \
--parameters @azuredeploy.parameters.json \
--parameters appServicePlanPortalName=$ASP sku=$SKU \
--parameters webAppName=$APP_NAME repoUrl=$APP_REPO branch=$APP_BRANCH \
--template-file "azuredeploy.json"

# Configure to CI/CD github actions
az webapp deployment source config --name $APP_NAME \
--resource-group $RG --repo-url $APP_REPO \
--branch $APP_BRANCH --git-token $TOKEN


# deploy container using CLI commands

# # 1. Create appservice plan ---- Created using deployment template above.
# az appservice plan create --name $ASP --resource-group $RG --sku $SKU --is-linux

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


echo "Webhook URL for Docker Hub repo:"
cat webhook_url.txt