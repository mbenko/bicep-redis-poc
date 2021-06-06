// This trigger runs on a timer to run an export of Redis Cache to a blob storage account
// We generate a SAS via the Azure-Storage package, then call the management endpoint to peform the extract

var count = 0;
const azure = require('azure-storage');
const https = require('https');

module.exports = async function (context, myTimer) {
    var timeStamp = new Date().toISOString();
    count++;

    if (myTimer.isPastDue)
    {
        context.log('***> fnTimerExportRedis() is running late!');
    }
    context.log('['+count+']---> fnTimerExportRedis() trigger function started!', timeStamp);   

    // REST Call to export from Redis
    context.log("--> HostURL: " + process.env.SRC_CLUSTER_NAME);
    context.log("--> Path:    " + process.env.SRC_EXPORT_PATH)
    // ExportRedis(context);
    
    // Copy Blob from export to 2nd storage account
    //context.bindings.outBlob = context.bindings.inBlob;
    
    context.log('['+count+']---> fnTimerExportRedis() timer trigger function complete!', timeStamp);   
};

function ExportRedis(context) {

    // this block does the export call to redisEnterprise:

    var blobname = process.env.SRC_CLUSTER_NAME + "_" + count;
    var hostUrl = "https://management.azure.com";
    var sas = generateSasToken(context, process.env.SRC_STORAGE, 'exports', blobname,  "rwadl");

    context.log("sas.uri: " + sas.uri);
    context.log("sas.token: " + sas.token);

    data = JSON.stringify({
        sasUri: sas.uri
    }); 

    const options = {
        hostname: hostUrl,
        port: 443,
        path: process.env.SRC_EXPORT_PATH,
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Content-Length': data.length
        }
    }

    const req = https.request(options, res => {
        console.log(`statusCode: ${res.statusCode}`)
      
        res.on('data', d => {
          process.stdout.write(d)
        })
      })
      
      req.on('success', rc => {
          context.log("Complete!")
        })

      req.on('error', error => {
        context.log(error)
      })
      
      req.write(data)
      req.end()

}

// Create a service SAS for a blob container
function generateSasToken(context, connection, container, blobName, permissions) {
    var connString = connection;
    var blobService = azure.createBlobService(connString);

    // Create a SAS token that expires in an hour
    // Set start time to five minutes ago to avoid clock skew.
    var startDate = new Date();
    startDate.setMinutes(startDate.getMinutes() - 5);
    var expiryDate = new Date(startDate);
    expiryDate.setMinutes(startDate.getMinutes() + 60);

    permissions = permissions || azure.BlobUtilities.SharedAccessPermissions.READ;

    var sharedAccessPolicy = {
        AccessPolicy: {
            Permissions: permissions,
            Start: startDate,
            Expiry: expiryDate
        }
    };
    
    var sasToken = blobService.generateSharedAccessSignature(container, blobName, sharedAccessPolicy);
    
    return {
        token: sasToken,
        uri: blobService.getUrl(container, blobName, sasToken, true)
    };
}