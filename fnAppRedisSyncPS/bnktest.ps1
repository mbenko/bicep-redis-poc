#The first two lines have nothing to do with the configuration, but make some space below in the blue part of the ISE

Set-Location C:\Temp
Clear-Host

 #So that you can carry out the configuration, you need the necessary cmdlets, these are contained in the module Az (is the higher-level module from a number of submodules)

Install-Module -Name Az -Force -AllowClobber -Verbose

#Log into Azure
Connect-AzAccount

#Select the correct subscription

Get-AzContext

Get-AzSubscription

Get-AzSubscription -SubscriptionName "your subscription name" | Select-AzSubscription

 

#Variables
$location = "centralus"
$rgname = "rg-redis-poc"
$storename = "bnkredispoccus01"
$container = "testcontainer"



#We need at least one Storage Account Key
$keys = Get-AzStorageAccountKey -Name $storename -ResourceGroupName $rgname

#Now we need to create Storage context
$context = New-AzStorageContext -StorageAccountName $storename -StorageAccountKey $keys[0].Value

#Once we have it, let’s create a storage container
New-AzStorageContainer -Context $context -Name $container

#Now we have required pre-requisites to create an SAS
$token = New-AzStorageContainerSASToken -Context $context -Name $container -Permission rwd

#Now we need to create Storage Container context
$containercontext = New-AzStorageContext -SasToken $token -StorageAccountName twstorage75

#Let's upload a file to the Storage Container
Set-AzStorageBlobContent -Context $containercontext -Container $container -File C:\Temp\test.txt

#List the blobs in the container
Get-AzStorageBlob -Container bilder -Context $context | select Name, Blobtype, LastModified
 
Now you have used the PowerShell to create an Azure Storage Account and an Shared Access Signature! Congratulations!
 
#Delete all resources (when you no longer need it)

Remove-AzResourceGroup -Name $rgname -Force