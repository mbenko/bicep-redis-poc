
var appName = 'bnkredispoc'
var fnLoc = 'CentralUs'
var drLoc = 'EastUS'
var storageNameCUS = '${appName}cus01'
var storageNameEUS = '${appName}eus01'
var hostingPlanName = '${appName}-plan'
var appInsightsName = '${appName}-ai'
var fnAppName = '${appName}-fn'
var redisCUS = '${appName}-cus'
var redisEUS = '${appName}-eus'
var SRC_DATABASE_NAME = 'default'
var DEST_DATABASE_NAME = 'default'

resource storageCUS 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageNameCUS
  location: fnLoc 
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

resource storageEUS 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageNameEUS
  location: drLoc 
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

resource appInsights 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: appInsightsName
  location: fnLoc
  kind: 'web'
  properties: { 
    Application_Type: 'web'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
  tags: {
    // circular dependency means we can't reference functionApp directly  /subscriptions/<subscriptionId>/resourceGroups/<rg-name>/providers/Microsoft.Web/sites/<appName>"
     'hidden-link:/subscriptions/${subscription().id}/resourceGroups/${resourceGroup().name}/providers/Microsoft.Web/sites/${fnAppName}': 'Resource'
  }
}

resource hostingPlan 'Microsoft.Web/serverfarms@2020-10-01' = {
  name: hostingPlanName
  location: fnLoc
  sku: {
    name: 'Y1' 
    tier: 'Dynamic'
  }
}

resource fnApp 'Microsoft.Web/sites@2021-01-01' = {
  name: fnAppName
  location: fnLoc
  kind: 'functionapp'
  properties: {
    httpsOnly: true
    serverFarmId: hostingPlan.id
    clientAffinityEnabled: true
    siteConfig: {
      appSettings: [
        {
          'name': 'APPINSIGHTS_INSTRUMENTATIONKEY'
          'value': appInsights.properties.InstrumentationKey
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageCUS.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageCUS.id, storageCUS.apiVersion).keys[0].value}'
        }
        {
          name: 'SRC_STORAGE'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageCUS.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageCUS.id, storageCUS.apiVersion).keys[0].value}'
        }
        {
          name: 'DEST_STORAGE'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageEUS.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageEUS.id, storageEUS.apiVersion).keys[0].value}'
        }
        {
          name: 'SRC_CLUSTER_NAME'
          value: redisCUS
        }
        {
          name: 'DEST_CLUSTER_NAME'
          value: redisEUS
        }
        {
          name: 'SRC_REDIS_DB_NAME'
          value: SRC_DATABASE_NAME
        }
        {
          name: 'DEST_REDIS_DB_NAME'
          value: DEST_DATABASE_NAME
        }
        {
          name: 'SRC_EXPORT_PATH'
          value: '${my_redis.id}/databases/${SRC_DATABASE_NAME}/export?api-version=2021-03-01'
        }
        {
          name: 'DEST_IMPORT_PATH'
          value: '${dr_redis.id}/databases/${DEST_DATABASE_NAME}/import?api-version=2021-03-01'
        }
        {
          'name': 'FUNCTIONS_EXTENSION_VERSION'
          'value': '~3'
        }
        {
          'name': 'FUNCTIONS_WORKER_RUNTIME'
          'value': 'powershell'
        }
        {
          'name': 'WEBSITE_NODE_DEFAULT_VERSION'
          'value': '~14'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageCUS.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageCUS.id, storageCUS.apiVersion).keys[0].value}'
        }
      
        // WEBSITE_CONTENTSHARE will also be auto-generated - https://docs.microsoft.com/en-us/azure/azure-functions/functions-app-settings#website_contentshare
        // WEBSITE_RUN_FROM_PACKAGE will be set to 1 by func azure functionapp publish
      ]
    }
  }

  dependsOn: [
    appInsights
    hostingPlan
    storageCUS
  ]
}

resource my_redis 'Microsoft.Cache/redisEnterprise@2021-03-01' = {
  name: redisCUS
  location: fnLoc
  sku: {
    name: 'Enterprise_E10'
    capacity: 2
  } 
  
}

resource my_db 'Microsoft.Cache/redisEnterprise/databases@2021-03-01' = {
  name: SRC_DATABASE_NAME
  parent: my_redis
}

resource dr_redis 'Microsoft.Cache/redisEnterprise@2021-03-01' = {
  name: redisEUS
  location: drLoc
  sku: {
    name: 'Enterprise_E10'
    capacity: 2
  } 
}

resource dr_db 'Microsoft.Cache/redisEnterprise/databases@2021-03-01' = {
  name: DEST_DATABASE_NAME
  parent: dr_redis
}

