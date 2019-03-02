exports.handler = async(event) => {

  console.log('SQS Trigger fired event: ' + JSON.stringify(event.body, null, 2));

  return "Hello from Lambda"
}