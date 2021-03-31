$params = Get-Content ..\params.json | ConvertFrom-Json

docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=$($params.saPassword)" `
   -p 1433:1433 --name sql1 -h sql1 `
   -d testdb:1