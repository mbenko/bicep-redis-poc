using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

write-host "Cluster: $env:SRC_CLUSTER_NAME"
Write-host "Storage: $env:SRC_STORAGE"
set-variable -name "container" -value "exports"
set-variable -name "rgname" -value "rg-redis-poc"

#We need at least one Storage Account Key
$keys = Get-AzStorageAccountKey -Name $env:SRC_Storage_NAME -ResourceGroupName $rgname

$src_key = $keys[0].Value

#Now we need to create Storage context5
$context = New-AzStorageContext -StorageAccountName $env:SRC_STORAGE_NAME -StorageAccountKey $keys[0].Value

#Once we have it, let’s create a storage container
New-AzStorageContainer -Context $context -Name $container -errorAction SilentlyContinue

#Now we have required pre-requisites to create an SAS
$token = New-AzStorageContainerSASToken -Context $context -Name $container -Permission rwd
write-host "Token: $token"

Export-AzRedisEnterpriseCache -ResourceGroupName $rgname -Name $env:SRC_CLUSTER_NAME -SasUri "https://$env:SRC_STORAGE_NAME.blob.core.windows.net/$container$token;$src_key"

# $cmd = "Export-AzRedisEnterpriseCache -ResourceGroupName $rgname -Name $env:SRC_CLUSTER_NAME -SasUri /"https://$env:SRC_STORAGE_NAME.blob.core.windows.net/$container$token;$src_key/""

# write-host "Export complete! ($cmd)"


# Interact with query parameters or the body of the request.
$name = $Request.Query.Name
if (-not $name) {
    $name = $Request.Body.Name
}

$body = "Export complete to $env:SRC_STORAGE_NAME - $container"

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})



