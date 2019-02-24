console.log('post() function starts')

const AWS = require('aws-sdk')

const dynamodbClient = new AWS.DynamoDB.DocumentClient({region: 'ap-southeast-2'})
const s3Client = new AWS.S3({apiVersion: '2006-03-01', region: 'ap-southeast-2'})

exports.handler = function(event, context, callback){

  console.log('processing event data: ' + JSON.stringify(event.body, null, 2))

  let data = JSON.parse(event.body)
  console.log('data is : ' + data)

  let params =  {
    Item: {
      Id: generateUUID(),
      Name: data.name ? data.name : "Anonymous",
      Tip: data.tip,
      Category: data.category
    },

    TableName: 'IdeationAWS'
  };

  console.log('Adding item into database : ' + JSON.stringify(params.Item))

  dynamodbClient.put(params, function(error,data){

    if(error) {
      console.error('Error thrown: ' + JSON.stringify(error))

      callback(error, null)
    } else {
      console.log('Response data: ' + JSON.stringify(data))
      
      let response = {
        "statusCode": 200,
        "headers": {
          "Content-Type": "application/json"
        },
        "body": JSON.stringify(data)
      };
      
      callback(null, response);
    }
  });

  // Create the parameters for calling listObjects
  var bucketParams = {
    Bucket : 'ideation-aws-data-bucket',
  };

  // Call S3 to obtain a list of the objects in the bucket
  s3Client.listObjects(bucketParams, function(error, data) {
    if (error) {
      console.log("Error: ", error);
    } else {
      console.log("Data in bucket: ", data);
    }
  });
}

function generateUUID() {

  // Generate RFC4122 version 4 compliant UUID 
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
    var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
    return v.toString(16);
  });
}