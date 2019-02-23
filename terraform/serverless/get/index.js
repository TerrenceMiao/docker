console.log('get() function starts');

const AWS = require('aws-sdk');

const dynamodbClient = new AWS.DynamoDB.DocumentClient({region: 'ap-southeast-2'});

exports.handler = function(event, context, callback) {

  console.log('processing the following event`: %j', event);

  let scanningParameters = {
    TableName: 'IdeationAWS',
    Limit: 100 //maximum result of 100 items
  };

  // In DynamoDB scan looks through your entire table and fetches all data
  dynamodbClient.scan(scanningParameters, function (error, data) {
    
    if (error) {
      console.error('Error thrown: ' + JSON.stringify(error))

      callback(error, null);
    } else {
      console.log('Response data: ' + JSON.stringify(data))
    
      var response = {
        "statusCode": 200,
        "headers": {
          "Content-Type": "application/json"
        },
        "body": JSON.stringify(data)
      };
    
      callback(null, response);
    }
  })
}
