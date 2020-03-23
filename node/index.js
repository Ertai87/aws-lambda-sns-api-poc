const AWS = require('aws-sdk');

exports.snsHandler = (event, context, callback) => {
    var params = {
        Message: event.body + " apigateway",
        TopicArn: "arn:aws:sns:us-east-1:641609470517:message-topic"
    }
    new AWS.SNS({apiVersion: '2010-03-31'}).publish(params).promise()
        .then(data => console.log("Successfully published message '" + event.body + "' to SNS"))
        .then(() => callback(null, {
            statusCode: 200,
            body: ''
        }))
        .catch(err => console.log("Error: " + err));
}

exports.dynamodbHandler = (event, context) => {
    event.Records.forEach(record => {
        var params = {
            Item: {
             id: record.messageId,
             message: JSON.parse(record.body).Message + " sns"
            },
            TableName:'MessagesTable'
        };
        new AWS.DynamoDB.DocumentClient({region:'us-east-1'}).put(params).promise()
            .then(data => console.log("Successfully published message with ID " + record.messageId + " to DynamoDB"))
            .catch(err => console.log("Error: " + err));
    });
}