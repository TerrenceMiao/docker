// Lambda function for Node.js 8.10 runtime
// Triggered from SQS Queue, send message body lines to Sumo logic http endpoint 
// https://boylesoftware.com/blog/calling-restful-apis-from-inline-aws-lambda-functions/
'use strict';

// Sumo logic http endpoint details
const sumoHostname = 'collectors.au.sumologic.com';
const sumoUri = '/receiver/v1/http/[key]';

// FX Rates from European Central Bank
const fxHostname = 'api.exchangeratesapi.io';
const fxUri = '/latest';

// load AWS SDK module, which is always included in the runtime environment
const AWS = require('aws-sdk');

// define our target API as a "service"
const sumoService = new AWS.Service({

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

const fxService = new AWS.Service({

  // the API base URL
  endpoint: 'https://' + fxHostname,

  // Optional: don't parse API responses if define shapes of endpoint responses
  convertResponseTypes: false,

  // API endpoints
  apiConfig: {
    metadata: {
        protocol: 'rest-json' // API is JSON-based
    },
    operations: {
      GetFXRates: {
        http: {
          method: 'GET',
          requestUri: fxUri
        }
      }
    }
  }
});

const lambda = new AWS.Lambda({ region: 'ap-southeast-2' });

// disable AWS region related login in the SDK
sumoService.isGlobalEndpoint = true;
fxService.isGlobalEndpoint = true;

// async(event, context, callback) call will fail when make sync call to FXRates service
exports.handler = (event, context, callback) => {
    
  console.log('Processing event: ' + JSON.stringify(event, null, 2))

  var data = '';

  // Read event data
  if (event.hasOwnProperty('Records')) {
    event.Records.forEach(record => {
      const { body } = record;
      console.log('Triggered event body: ', body);
      data += body;
    });
  }
  
  console.log('Sending data:', data);
  
  sumoService.log({
    data: data
  }, (error, data) => {
    if (error) {
      console.error('>>> Sumo service error:', error);
      return callback(error);
    }

    console.log('New log added:', data);

    callback();
  });

  fxService.getFXRates({}, (error, data) => {
    if (error) {
      console.error('>>> FX Rates service error:', error);
      return callback(error);
    }

    console.log('FX Rates:', data);

    callback();
    
    let event = {
      "body": {
        "name": "European Central Bank",
        "category": "FX Rates",
        "tip": "European Central Bank FX minute rate",
        "rates": data.rates,
        "base": data.base,
        "date": data.date
      }
    };
    
    console.log('Saving data into DynamoDB:' + JSON.stringify(event, null, 2));

    lambda.invoke({
      FunctionName: 'ideationAWS-post',
      Payload: JSON.stringify(event, null, 2)
    }, (error, data) => {
      if (error) {
        console.error('>>> Lambda invoke error', error);
        return callback(error);
      }
    });
  });
};
