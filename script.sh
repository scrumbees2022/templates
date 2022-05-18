#!/usr/bin/env bash
RG=$(az group list --query [].name -o tsv)

az deployment group create \
--resource-group $RG \
--parameters @azuredeploy.parameters.json \
--template-file "azuredeploy.json"