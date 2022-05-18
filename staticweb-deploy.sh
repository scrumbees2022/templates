#!/usr/bin/env bash
RG=$(az group list --query [].name -o tsv)
TOKEN=$1

az deployment group create \
--resource-group $RG \
--parameters repositoryToken=$TOKEN @staticweb-parameters.json \
--template-file "staticweb-template.json"