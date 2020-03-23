const AWS = require('aws-sdk');
const Promise = require('bluebird');
const dbClient = Promise.promisifyAll(new AWS.DynamoDB.DocumentClient({region:'us-east-1'}));

exports.dynamodbHandler = (event, context, callback) => {
    event.Records.forEach(record => {
     var params = {
         Item: {
             id: record.messageId,
             message: record.body + " sns"
         },
         TableName:'MessagesTable'
     };
     dbClient.putAsync(params)
         .then(data => callback(null, data))
         .catch(err => callback(err, null));
    });
}