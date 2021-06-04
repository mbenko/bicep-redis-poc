module.exports = async function (context, myTimer) {
    var timeStamp = new Date().toISOString();
    
    if (myTimer.isPastDue)
    {
        context.log('JavaScript is running late!');
    }
    context.log('JavaScript timer trigger function started!', timeStamp);   

    // REST Call to export from Redis
    ExportRedis(context);
    context.log("HostURL: " + process.env.SRC_CLUSTER_NAME);
    context.log("Path:    " + process.env.SRC_EXPORT_PATH)

    // Copy Blob from export to 2nd storage account
    context.bindings.outBlob = context.bindings.inBlob;
    context.done();

    // Call FN to import to Redis
    ImportRedis(context)

    context.log('JavaScript timer trigger function complete!', timeStamp);   
};

function ExportRedis(context) {

    // this block does the export call to redisEnterprise:

    // . envars
    
    //DATE=gdate 			// Use gdate to mimic linux date on mac. Install thus: brew install coreutils
    //EXPIRY=$(${DATE:?} -u -d "60 minutes" '+%Y-%m-%dT%H:%MZ')
    //TOKEN=$(az storage container generate-sas --account-key $SRC_ACCOUNT_ACCESS_KEY --account-name $SRC_ACCOUNT --expiry "${EXPIRY}" --name $SRC_CONTAINER --permissions dlrw | tr -d '"')
    //SAS_URI="https://${SRC_ACCOUNT:?}.blob.core.windows.net/${SRC_CONTAINER:?}?${TOKEN:?}"
    //
    //
    //JSON_BODY="{ \"sasUri\": \"${SAS_URI:?};${SRC_ACCOUNT_ACCESS_KEY:?}\" }"
    //
    //az rest -m POST -u https://management.azure.com/subscriptions/${SUBSCRIPTION_ID:?}/resourceGroups/${RESOURCE_GROUP_NAME:?}/providers/Microsoft.Cache/redisEnterprise/${SRC_CLUSTER_NAME:?}/databases/${SRC_DATABASE_NAME:?}/export?api-version=2021-03-01 -b "$JSON_BODY"   

    var hostUrl = "https://management.azure.com";

    const options = {
        hostname: hostUrl,
        port: 443,
        path: process.env.SRC_EXPORT_PATH,
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Content-Length': body.length
        }
    }

    var response = '';
    const request = http.request(options, (res) => {
        context.log(`statusCode: ${res.statusCode}`)

        res.on('data', (d) => {
            response += d;
        })

        res.on('end', (d) => {
            context.res = {
                body: response
            }
            context.done();
        })
    })

    request.on('error', (error) => {
        context.log.error(error)
        context.done();
    })
}

function ImportRedis(context) {
    // this block does the import call to redisEnterprise:
    //. envars
    //DEST_BLOB_NAME=${1:?No blob name given}
    //DATE=gdate 			// Use gdate to mimic linux date on mac. Install thus: brew install coreutils
    //EXPIRY=$(${DATE} -u -d "60 minutes" '+%Y-%m-%dT%H:%MZ')
    //TOKEN=$(az storage blob generate-sas --account-key ${DEST_ACCOUNT_ACCESS_KEY:?} --account-name ${DEST_ACCOUNT:?} --expiry "${EXPIRY:?}" --container-name ${DEST_CONTAINER:?} --name ${DEST_BLOB_NAME:?} --permissions r | tr -d '"')
    //SAS_URI="https://${DEST_ACCOUNT:?}.blob.core.windows.net/${DEST_CONTAINER:?}/${DEST_BLOB_NAME:?}?${TOKEN:?}"
    //JSON_BODY="{ \"sasUri\": \"${SAS_URI};${DEST_ACCOUNT_ACCESS_KEY}\" }"
    //az rest -m POST -u https://management.azure.com/subscriptions/${SUBSCRIPTION_ID:?}/resourceGroups/${RESOURCE_GROUP_NAME:?}/providers/Microsoft.Cache/redisEnterprise/${DEST_CLUSTER_NAME:?}/databases/${DEST_DATABASE_NAME:?}/import?api-version=2021-03-01 -b "$JSON_BODY"

}