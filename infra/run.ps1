$params = Get-Content ..\params.json | ConvertFrom-Json

$image = "$($params.acr).azurecr.io/testdb:1"
$acrLoginServer=$(az acr show --name $params.acr --resource-group $params.rg --query "loginServer" --output tsv)
Write-Host $acrLoginServer

$saPassword = $(az keyvault secret show --vault-name $params.kv -n $params.saPasswordName --query value -o tsv)

az container create `
    --name $params.aci `
    --resource-group $params.rg `
    --image $image `
    --port 1433 `
    --cpu 1 `
    --memory 3.5 `
    -e "ACCEPT_EULA=Y" "SA_PASSWORD=$saPassword" `
    --registry-login-server $acrLoginServer `
    --registry-username $(az keyvault secret show --vault-name $params.kv -n "$($params.acr)-pull-usr" --query value -o tsv) `
    --registry-password $(az keyvault secret show --vault-name $params.kv -n "$($params.acr)-pull-pwd" --query value -o tsv) `
    --dns-name-label $params.aci `
    --query ipAddress.fqdn
