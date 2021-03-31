$params = Get-Content ..\params.json | ConvertFrom-Json

az group create -l australiaeast -n $params.rg
az acr create -g $params.rg -n $params.acr --sku "Standard"
az keyvault create -g $params.rg -n $params.kv

az keyvault secret set `
  --vault-name $params.kv `
  --name "$($params.acr)-pull-pwd" `
  --value $(az ad sp create-for-rbac `
                --name "http://$($params.acr)-pull" `
                --scopes $(az acr show --name $params.acr --query id --output tsv) `
                --role acrpull `
                --query password `
                --output tsv)

az keyvault secret set `
    --vault-name $params.kv `
    --name "$($params.acr)-pull-usr" `
    --value $(az ad sp show --id "http://$($params.acr)-pull" --query appId --output tsv)

az keyvault secret set `
    --vault-name $params.kv `
    --name $params.saPasswordName `
    --value $params.saPassword