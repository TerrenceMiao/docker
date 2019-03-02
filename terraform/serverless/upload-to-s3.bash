#!/usr/bin/env bash

## Zip the lambda functions
cd get
rm -r getLambda.zip 
zip -r getLambda.zip index.js
cd ..

cd post
rm -r postLambda.zip
zip -r postLambda.zip index.js
cd ..

cd async
rm -r asyncLambda.zip
zip -r asyncLambda.zip index.js
cd ..

## Upload code to s3
aws s3 cp get/getLambda.zip s3://ideation-aws-node-bucket/v1.0.0/getLambda.zip
aws s3 cp post/postLambda.zip s3://ideation-aws-node-bucket/v1.0.0/postLambda.zip
aws s3 cp async/asyncLambda.zip s3://ideation-aws-node-bucket/v1.0.0/asyncLambda.zip
