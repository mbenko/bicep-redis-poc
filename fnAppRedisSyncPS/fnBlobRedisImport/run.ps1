# Input bindings are passed in via param block.
param([byte[]] $InputBlob, $TriggerMetadata)

# Write out the blob name and size to the information log.
Write-Host "PowerShell Blob trigger function Processed blob! Name: $($TriggerMetadata.Name) Size: $($InputBlob.Length) bytes"

write-host "Cluster: $env:DEST_CLUSTER_NAME"
Write-host "Storage: $env:DEST_STORAGE"
set-variable -name "container" -value "imports"
set-variable -name "rgname" -value "rg-redis-poc"
$filename = $TriggerMetadata.Name

#We need at least one Storage Account Key
$keys = Get-AzStorageAccountKey -Name $env:DEST_Storage_NAME -ResourceGroupName $rgname

$src_key = $keys[0].Value

#Now we need to create Storage context5
$context = New-AzStorageContext -StorageAccountName $env:DEST_STORAGE_NAME -StorageAccountKey $keys[0].Value

#Once we have it, let’s create a storage container
New-AzStorageContainer -Context $context -Name $container -errorAction SilentlyContinue

#Now we have required pre-requisites to create an SAS
$token = New-AzStorageContainerSASToken -Context $context -Name $container -Permission rwd 
write-host "Token: $token"

Import-AzRedisEnterpriseCache -Name $env:DEST_CLUSTER_NAME -ResourceGroupName $rgname -SasUri "https://$env:DEST_STORAGE_NAME.blob.core.windows.net/$container/$filename$token;$src_key"

