using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)



# Write to the Azure Functions log stream.
Write-Host "---> fnHttpShowEnv"

$body = "ENV - SETTINGS"
$body = $Body + " >RESOURCE_GROUP:    $env:RESOURCE_GROUP"
$body = $Body + " >SRC_CONTAINER:     $env:SRC_CONTAINER"
$body = $Body + " >SRC_CLUSTER_NAME:  $env:SRC_CLUSTER_NAME"
$body = $Body + " >SRC_STORAGE_NAME:  $env:SRC_STORAGE_NAME"


# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})
