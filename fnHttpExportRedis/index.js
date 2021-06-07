
var count = 0;
const azure = require('azure-storage');
const https = require('https');

module.exports = async function (context, req) {
    var timeStamp = new Date().toISOString();

    context.log('['+count+']---> fnHttpExportRedis() HTTP trigger Start ', timeStamp);

    ExportRedis(context);
    
    // Copy Blob from export to 2nd storage account
    //context.bindings.outBlob = context.bindings.inBlob;
    
    context.log('['+count+']---> fnHttpExportRedis() http trigger function complete! ', timeStamp);   

}

function ExportRedis(context) {

    // this block does the export call to redisEnterprise:
    var timeStamp = new Date().toISOString();
    var blobname = process.env.SRC_CLUSTER_NAME + "-" + count;
    var hostUrl = "https://management.azure.com"+process.env.SRC_EXPORT_PATH;
    var sas = generateSasToken(context, process.env.SRC_STORAGE, 'exports', blobname,  "rwa");


    context.log("  > blobname: " + blobname);
    context.log("  > host: " + hostUrl);
    context.log("  > sas.uri: " + sas.uri);
    context.log("  > sas.token: " + sas.token);
    
    data = JSON.stringify({
        sasUri: sas.uri
    }); 

    context.log("  > data: " + data);

    const options = {
        hostname: hostUrl,
        port: 443,
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Content-Length': data.length
        }
    }

    const myReq = https.request(options, res => {

        context.log('  > statusCode: ${res.statusCode}')
        
        res.on('data', d => {
            process.stdout.write(d)
        })
    })
    
    myReq.on('success', rc => {
        context.log('['+count+']---> fnHttpExportRedis() : Request SUCCESS!')
        myReq.end()
    })

    myReq.on('error', error => {
        console.log(" **ERROR** > " + error);
        context.log(" **ERROR** > " + error);
    })
      
    myReq.write(data)
    context.log('['+count+']---> fnHttpExportRedis() - http Request sent');
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