$params = Get-Content ..\params.json | ConvertFrom-Json

$image = "$($params.acr).azurecr.io/testdb:2"

docker build --build-arg DBNAME=test --build-arg 'PASSWORD=$($params.saPassword)' . -t $image
az acr login -n $params.acr
docker push $image