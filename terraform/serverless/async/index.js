// Lambda function for Node.js 8.10 runtime
// Triggered from SQS Queue, send message body lines to Sumo logic http endpoint 
// https://boylesoftware.com/blog/calling-restful-apis-from-inline-aws-lambda-functions/
'use strict';

// Sumo logic http endpoint details
const sumoHostname = 'collectors.au.sumologic.com';
const sumoUri = '/receiver/v1/http/[key]';

// load AWS SDK module, which is always included in the runtime environment
const AWS = require('aws-sdk');

// define our target API as a "service"
const service = new AWS.Service({

  // the API base URL
  endpoint: 'https://' + sumoHostname,

  // Optional: don't parse API responses if define shapes of endpoint responses
  convertResponseTypes: false,

  // API endpoints
  apiConfig: {
    metadata: {
        protocol: 'rest-json' // API is JSON-based
    },
    operations: {
      Log: {
        http: {
          method: 'POST',
          requestUri: sumoUri
        },
        input: {
          type: 'structure',
          required: [ 'data' ],
          // use "data" input for the request payload
          payload: 'data',
          members: {
            'data': {
              type: 'string'
            }
          }
        }
      }
    }
  }
});

// disable AWS region related login in the SDK
service.isGlobalEndpoint = true;

exports.handler = async (event, context, callback) => {
    
  var data = '';

  // Read event data
  event.Records.forEach(record => {
    const { body } = record;
    console.log('SQS Trigger fired event body: ', body);
    data += body;
  });
  
  console.log('Sending data:', data);
  
  service.log({
    data: data
  }, (error, data) => {
    if (error) {
      console.error('>>> Operation error:', error);
      return callback(error);
    }

    console.log('New log added:', data);

    callback();
  });
};
