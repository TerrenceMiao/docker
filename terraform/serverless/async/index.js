// Lambda function for Node.js 8.10 runtime
// Triggered from SQS Queue, send message body lines to Sumo logic http endpoint 

// Sumo logic http endpoint details
const sumoHostname = 'collectors.au.sumologic.com';
const sumoUri = '/receiver/v1/http/[key]';

const https = require('https');

exports.handler = async (event, context) => {
    
  var data = '';

  // Read event data
  event.Records.forEach(record => {
    const { body } = record;
    console.log('SQS Trigger fired event body: ', body);
    data += body;
  });
  
  console.log('Sending data:', data);
  
  return new Promise((resolve, reject) => {
    const options = {
      host: sumoHostname,
      port: 443,
      path: sumoUri,
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Content-Length': data.length
      }
    };

    const req = https.request(options, (res) => {
      resolve('Success');
    });

    req.on('Error', (e) => {
      reject(e.message);
    });

    // send the request
    req.write(data);
    req.end();
  });
};
