az login

cd .\Deploy

az deployment group create --name redis-poc-v04 --resource-group rg-redis-poc --template-file main.bicep

cd ..\fnAppRedisSyncPS

func azure functionapp publish bnkredispoc-fn

## after deploy of FnApp need to enable system assigned identity and manually apply Azure role assignment to service to enable access to Redis APIs
## for demo purposes I assigned it to Owner of the Resource Group scope