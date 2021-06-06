module.exports = async function (context, myBlob) {
    context.log("---> fnBlobCopySrcToDest Started...");
    context.bindings.destBlob = context.bindings.srcBlob;
    context.log("---> fnBlobCopySrxToDest Complete! \n Blob:", context.bindingData.blobTrigger, "\n Blob Size:", myBlob.length, "Bytes");
    context.done();
};