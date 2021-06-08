using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)


# Write to the Azure Functions log stream.
Write-Host "---> fnHttpRedisExportPS() - START: PowerShell HTTP trigger function processed a request."
$ErrorActionPreference = 'Stop'

write-host "Cluster: $env:SRC_CLUSTER_NAME"
Write-host "Storage: $env:SRC_STORAGE"
set-variable -name "container" -value "exports"
set-variable -name "rgname" -value "rg-redis-poc"

#We need at least one Storage Account Key
$keys = Get-AzStorageAccountKey -Name $env:SRC_STORAGE_NAME -ResourceGroupName $env:RESOURCE_GROUP

$src_key = $keys[0].Value

#Now we need to create Storage context5
$context = New-AzStorageContext -StorageAccountName $env:SRC_STORAGE_NAME -StorageAccountKey $keys[0].Value

#Once we have it, let’s create a storage container
New-AzStorageContainer -Context $context -Name $env:SRC_CONTAINER -errorAction SilentlyContinue

#Now we have required pre-requisites to create an SAS
$token = New-AzStorageContainerSASToken -Context $context -Name $env:SRC_CONTAINER -Permission rwd
write-host "Token: $token"

Export-AzRedisEnterpriseCache -ResourceGroupName $rgname -Name $env:SRC_CLUSTER_NAME -SasUri "https://$env:SRC_STORAGE_NAME.blob.core.windows.net/$env:SRC_CONTAINER$token;$src_key"


$body = "---> fnHttpRedisExportPS() DONE!  Export complete to $env:SRC_STORAGE_NAME - $container"

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})



