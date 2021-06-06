param sites_bnkfntest2_name string = 'bnkfntest2'
param serverfarms_ASP_rgredispoc_8161_externalid string = '/subscriptions/b8c7d821-4fbb-4089-8978-b966512a6a45/resourceGroups/rg-redis-poc/providers/Microsoft.Web/serverfarms/ASP-rgredispoc-8161'

resource sites_bnkfntest2_name_resource 'Microsoft.Web/sites@2018-11-01' = {
  name: sites_bnkfntest2_name
  location: 'Central US'
  tags: {
    CostCenter: 'ContosoIT'
  }
  kind: 'functionapp'
  identity: {
    principalId: 'efe7a26f-01ef-404f-be5a-1e4f9365f674'
    tenantId: '1f37530a-d3ea-4420-98c6-60310dcc1a7a'
    type: 'SystemAssigned'
  }
  properties: {
    enabled: true
    hostNameSslStates: [
      {
        name: '${sites_bnkfntest2_name}.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: '${sites_bnkfntest2_name}.scm.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
    serverFarmId: serverfarms_ASP_rgredispoc_8161_externalid
    reserved: false
    isXenon: false
    hyperV: false
    siteConfig: {
      numberOfWorkers: 1
      alwaysOn: false
      http20Enabled: false
    }
    scmSiteAlsoStopped: false
    clientAffinityEnabled: false
    clientCertEnabled: false
    hostNamesDisabled: false
    containerSize: 1536
    dailyMemoryTimeQuota: 0
    httpsOnly: false
    redundancyMode: 'None'
  }
}

resource sites_bnkfntest2_name_web 'Microsoft.Web/sites/config@2018-11-01' = {
  name: '${sites_bnkfntest2_name_resource.name}/web'
  location: 'Central US'
  tags: {
    CostCenter: 'ContosoIT'
  }
  properties: {
    numberOfWorkers: 1
    defaultDocuments: [
      'Default.htm'
      'Default.html'
      'Default.asp'
      'index.htm'
      'index.html'
      'iisstart.htm'
      'default.aspx'
      'index.php'
    ]
    netFrameworkVersion: 'v4.0'
    phpVersion: '5.6'
    requestTracingEnabled: false
    remoteDebuggingEnabled: false
    remoteDebuggingVersion: 'VS2019'
    httpLoggingEnabled: false
    logsDirectorySizeLimit: 35
    detailedErrorLoggingEnabled: false
    publishingUsername: '$bnkfntest2'
    azureStorageAccounts: {}
    scmType: 'None'
    use32BitWorkerProcess: true
    webSocketsEnabled: false
    alwaysOn: false
    managedPipelineMode: 'Integrated'
    virtualApplications: [
      {
        virtualPath: '/'
        physicalPath: 'site\\wwwroot'
        preloadEnabled: false
      }
    ]
    loadBalancing: 'LeastRequests'
    experiments: {
      rampUpRules: []
    }
    autoHealEnabled: false
    localMySqlEnabled: false
    managedServiceIdentityId: 10172
    ipSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 1
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 1
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictionsUseMain: false
    http20Enabled: false
    minTlsVersion: '1.2'
    ftpsState: 'AllAllowed'
    reservedInstanceCount: 0
  }
}

resource sites_bnkfntest2_name_c4c44c411f204fb1af664797c7f20c15 'Microsoft.Web/sites/deployments@2018-11-01' = {
  name: '${sites_bnkfntest2_name_resource.name}/c4c44c411f204fb1af664797c7f20c15'
  location: 'Central US'
  properties: {
    status: 4
    author_email: 'N/A'
    author: 'N/A'
    deployer: 'ZipDeploy'
    message: 'Created via a push deployment'
    start_time: '6/6/2021 9:08:41 PM'
    end_time: '6/6/2021 9:08:49 PM'
    active: true
  }
}

resource sites_bnkfntest2_name_fnBlobCopySrcToDest 'Microsoft.Web/sites/functions@2018-11-01' = {
  name: '${sites_bnkfntest2_name_resource.name}/fnBlobCopySrcToDest'
  location: 'Central US'
  properties: {
    script_root_path_href: 'https://bnkfntest2.azurewebsites.net/admin/vfs/site/wwwroot/fnBlobCopySrcToDest/'
    script_href: 'https://bnkfntest2.azurewebsites.net/admin/vfs/site/wwwroot/fnBlobCopySrcToDest/index.js'
    config_href: 'https://bnkfntest2.azurewebsites.net/admin/vfs/site/wwwroot/fnBlobCopySrcToDest/function.json'
    href: 'https://bnkfntest2.azurewebsites.net/admin/functions/fnBlobCopySrcToDest'
    config: {}
  }
}

resource sites_bnkfntest2_name_fnBlobImportRedis 'Microsoft.Web/sites/functions@2018-11-01' = {
  name: '${sites_bnkfntest2_name_resource.name}/fnBlobImportRedis'
  location: 'Central US'
  properties: {
    script_root_path_href: 'https://bnkfntest2.azurewebsites.net/admin/vfs/site/wwwroot/fnBlobImportRedis/'
    script_href: 'https://bnkfntest2.azurewebsites.net/admin/vfs/site/wwwroot/fnBlobImportRedis/index.js'
    config_href: 'https://bnkfntest2.azurewebsites.net/admin/vfs/site/wwwroot/fnBlobImportRedis/function.json'
    href: 'https://bnkfntest2.azurewebsites.net/admin/functions/fnBlobImportRedis'
    config: {}
  }
}

resource sites_bnkfntest2_name_fnHttpExportRedis 'Microsoft.Web/sites/functions@2018-11-01' = {
  name: '${sites_bnkfntest2_name_resource.name}/fnHttpExportRedis'
  location: 'Central US'
  properties: {
    script_root_path_href: 'https://bnkfntest2.azurewebsites.net/admin/vfs/site/wwwroot/fnHttpExportRedis/'
    script_href: 'https://bnkfntest2.azurewebsites.net/admin/vfs/site/wwwroot/fnHttpExportRedis/index.js'
    config_href: 'https://bnkfntest2.azurewebsites.net/admin/vfs/site/wwwroot/fnHttpExportRedis/function.json'
    href: 'https://bnkfntest2.azurewebsites.net/admin/functions/fnHttpExportRedis'
    config: {}
  }
}

resource sites_bnkfntest2_name_fnHttpGetSas 'Microsoft.Web/sites/functions@2018-11-01' = {
  name: '${sites_bnkfntest2_name_resource.name}/fnHttpGetSas'
  location: 'Central US'
  properties: {
    script_root_path_href: 'https://bnkfntest2.azurewebsites.net/admin/vfs/site/wwwroot/fnHttpGetSas/'
    script_href: 'https://bnkfntest2.azurewebsites.net/admin/vfs/site/wwwroot/fnHttpGetSas/index.js'
    config_href: 'https://bnkfntest2.azurewebsites.net/admin/vfs/site/wwwroot/fnHttpGetSas/function.json'
    href: 'https://bnkfntest2.azurewebsites.net/admin/functions/fnHttpGetSas'
    config: {}
  }
}

resource sites_bnkfntest2_name_fnTimerExportRedis 'Microsoft.Web/sites/functions@2018-11-01' = {
  name: '${sites_bnkfntest2_name_resource.name}/fnTimerExportRedis'
  location: 'Central US'
  properties: {
    script_root_path_href: 'https://bnkfntest2.azurewebsites.net/admin/vfs/site/wwwroot/fnTimerExportRedis/'
    script_href: 'https://bnkfntest2.azurewebsites.net/admin/vfs/site/wwwroot/fnTimerExportRedis/index.js'
    config_href: 'https://bnkfntest2.azurewebsites.net/admin/vfs/site/wwwroot/fnTimerExportRedis/function.json'
    href: 'https://bnkfntest2.azurewebsites.net/admin/functions/fnTimerExportRedis'
    config: {}
  }
}

resource sites_bnkfntest2_name_HttpTrigger1 'Microsoft.Web/sites/functions@2018-11-01' = {
  name: '${sites_bnkfntest2_name_resource.name}/HttpTrigger1'
  location: 'Central US'
  properties: {
    script_root_path_href: 'https://bnkfntest2.azurewebsites.net/admin/vfs/site/wwwroot/HttpTrigger1/'
    script_href: 'https://bnkfntest2.azurewebsites.net/admin/vfs/site/wwwroot/HttpTrigger1/index.js'
    config_href: 'https://bnkfntest2.azurewebsites.net/admin/vfs/site/wwwroot/HttpTrigger1/function.json'
    href: 'https://bnkfntest2.azurewebsites.net/admin/functions/HttpTrigger1'
    config: {}
  }
}

resource sites_bnkfntest2_name_sites_bnkfntest2_name_azurewebsites_net 'Microsoft.Web/sites/hostNameBindings@2018-11-01' = {
  name: '${sites_bnkfntest2_name_resource.name}/${sites_bnkfntest2_name}.azurewebsites.net'
  location: 'Central US'
  properties: {
    siteName: 'bnkfntest2'
    hostNameType: 'Verified'
  }
}