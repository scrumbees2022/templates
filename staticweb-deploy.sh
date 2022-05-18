#!/usr/bin/env bash
RG=$(az group list --query [].name -o tsv)
TOKEN=$1

az deployment group create \
--resource-group $RG \
--parameters @staticweb-parameters.json \
--parameters repositoryToken=$TOKEN \
--template-file "staticweb-template.json"