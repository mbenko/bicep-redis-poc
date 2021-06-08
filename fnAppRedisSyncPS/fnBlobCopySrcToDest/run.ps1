# Input bindings are passed in via param block.
param([byte[]] $InputBlob,  $TriggerMetadata)

Push-OutputBinding -Name OutputBlob -Value $InputBlob

# Write out the blob name and size to the information log.
Write-Host "PowerShell Blob trigger function Processed blob! Name: $($TriggerMetadata.Name) Size: $($InputBlob.Length) bytes"
