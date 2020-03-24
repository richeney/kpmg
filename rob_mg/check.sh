#!/bin/bash

displayname=AzurePolicyReporter
displayName=governance
secret=01f95231-85b1-4ab4-bcc3-8f8f101cde1c
managementGroup=DevSecOps

policyStatesResource=default
policyStatesResource=latest

echo -n "Checking registrationState for Microsoft.PolicyInsights... "
az provider show --namespace Microsoft.PolicyInsights --query registrationState --output tsv
query="resourceTypes[].operations[]|sort_by([], &name)|[].{name:name, isDataAction:isDataAction}"
az provider operation show --namespace Microsoft.PolicyInsights  --query "$query" --output table

# PolicyInsightsDataWriter="66bb4e9e-b016-4a94-8249-4c0511c2be84"
# ResourcePolicyContributor="36243c78-bf99-498c-9df9-86d9f8d28608"

echo "Policy Insights Data Writer (Preview):"
az role definition list --name "Policy Insights Data Writer (Preview)" --query "[].permissions[0]" --output jsonc

echo "Resource Policy Contributor:"
az role definition list --name "Resource Policy Contributor" --query "[].permissions[0]" --output jsonc


appId=$(az ad sp list --filter "displayName eq '"$displayName"'" --query "[].appId" --output tsv)
spObjectId=$(az ad sp show --id $appId --query objectId --output tsv)
appObjectId=$(az ad app show --id $appId --query objectId --output tsv)
tenantId=$(az ad sp show --id $appId --query '"odata.metadata"' | cut -d/ -f4)

cat <<EOF
tenantId:    $tenantId
appId:       $appId
appObjectId: $appObjectId
spObjectId:  $spObjectId
EOF



# Log in as the service principal
echo "Logging in as $displayName..."
echo "az login --service-principal --username $appId -p $secret --tenant $tenantId --output jsonc --query \"[].user\" --allow-no-subscriptions"
az login --service-principal --username $appId -p $secret --tenant $tenantId --output jsonc --query "[].user" --allow-no-subscriptions


# Test using Azure CLI

# az account management-group create --name $(uuidgen) --display-name DevSecOps
az account management-group list --output jsonc
mgName=$(az account management-group list --query "[?displayName == '"$managementGroup"'].name" --output tsv)
echo "$managementGroup: $mgName"

# Test the REST API endpoints

uri="https://management.azure.com/providers/Microsoft.Management/managementGroups/$mgName/providers/Microsoft.PolicyInsights/policyStates/"
api="api-version=2019-10-01"



## echo "Summarize for Management Groups"
# az rest --method GET --uri $uri/$policyStatesResource/summarize?$api
## Needs payload for the POST? Not defined on the page

## echo "List Query Results For Management Group"
az rest --method POST --uri $uri/$policyStatesResource/queryResults?$api

sleep 10
exit