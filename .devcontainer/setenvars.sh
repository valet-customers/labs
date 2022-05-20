#!/bin/bash
echo "Starting bootstrap.sh"
echo "1st parameter = $1 "
echo "2nd Parameter = $2 "

azdoProject="AZURE_DEVOPS_PROJECT="
azdoOrg="AZURE_DEVOPS_ORGANIZATION="
azdoInstance="AZURE_DEVOPS_INSTANCE_URL="
ghAccess="GITHUB_ACCESS_TOKEN="
azdoAccess="AZURE_DEVOPS_ACCESS_TOKEN="
ghInstanceUrl="GITHUB_INSTANCE_URL="

azdoInstanceUrl="https://dev.azure.com/$2"

value=`cat valet/.env.local`

result="${value/$azdoProject/$azdoProject$1}" 
result="${result/$azdoOrg/$azdoOrg$2}" 
result="${result/$azdoInstance/$azdoInstance$azdoInstanceUrl}" 
result="${result/$ghAccess/$ghAccess$3}" 
result="${result/$azdoAccess/$azdoAccess$4}" 
result="${result/$ghInstanceUrl/$ghInstanceUrl$5}" 

echo "$result" > valet/.env.local
