# Input bindings are passed in via param block.
param([byte[]] $InputBlob, $TriggerMetadata)
write-host "---> fnBlobRedisImport() Start"

$filename = $TriggerMetadata.Name
$ErrorActionPreference = 'Stop'

#We need at least one Storage Account Key
$keys = Get-AzStorageAccountKey -Name $env:DEST_Storage_NAME -ResourceGroupName $env:RESOURCE_GROUP

$src_key = $keys[0].Value

#Now we need to create Storage context5
$context = New-AzStorageContext -StorageAccountName $env:DEST_STORAGE_NAME -StorageAccountKey $keys[0].Value

#Once we have it, let’s create a storage container
New-AzStorageContainer -Context $context -Name $env:DEST_CONTAINER -errorAction SilentlyContinue

#Now we have required pre-requisites to create an SAS
$token = New-AzStorageContainerSASToken -Context $context -Name $env:DEST_CONTAINER -Permission rwd 
write-host "Token: $token"

Import-AzRedisEnterpriseCache -Name $env:DEST_CLUSTER_NAME -ResourceGroupName $env:RESOURCE_GROUP -SasUri "https://$env:DEST_STORAGE_NAME.blob.core.windows.net/$env:DEST_CONTAINER/$filename$token;$src_key"

# Remove-AzureStorageBlob -Container $env:DEST_CONTAINER -Blob $filename

write-host "---> fnBlobRedisImport() Complete - Name: $($TriggerMetadata.Name) Size: $($InputBlob.Length) bytes"
