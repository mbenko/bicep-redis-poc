// This trigger runs on a timer to run an export of Redis Cache to a blob storage account
// We generate a SAS via the Azure-Storage package, then call the management endpoint to peform the extract

var count = 0;

module.exports = async function (context, myTimer) {
    var timeStamp = new Date().toISOString();
    count++;

    if (myTimer.isPastDue)
    {
        context.log('***> fnTimerExportRedis() is running late!');
    }
    // context.log('['+count+']---> fnTimerExportRedis() trigger function started!', timeStamp);   

    // // REST Call to export from Redis
    // context.log("--> HostURL: " + process.env.SRC_CLUSTER_NAME);
    // context.log("--> Path:    " + process.env.SRC_EXPORT_PATH)
    // ExportRedis(context);
    
    // Copy Blob from export to 2nd storage account
    //context.bindings.outBlob = context.bindings.inBlob;
    
    context.log('['+count+']---> fnTimerExportRedis() timer trigger function complete!', timeStamp);   
};