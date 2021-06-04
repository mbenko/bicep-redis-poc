cd .\Deploy

az deployment group create --name redis-poc-v03 --resource-group rg-redis-poc --template-file main.bicep

func azure functionapp publish bnkredispoc-fn