#!/bin/sh
set -e
mkdir -p "graalvm_latest"
mkdir -p "graalvm_11-21.3"

#builds a native binary and zip
mvn clean install -P native


#builds a native binary and zip
docker build -f Dockerfile.graalvm -t lambda-graalvm .
#
#copy from the docker container to host
containerId=$(docker create -ti lambda-graalvm bash)
docker cp ${containerId}:/tmp/dist graalvm_latest

#builds a native binary and zip
docker build -f Dockerfile.graalvm-java11-21.3 -t lambda-graalvm-11-21.3 .
#
#copy from the docker container to host
containerId=$(docker create -ti lambda-graalvm-11-21.3)
docker cp ${containerId}:/tmp/dist graalvm_11-21.3

## Deploy lambdas

alias sam='sam.cmd'
sam deploy --no-confirm-changeset --no-fail-on-empty-changeset --stack-name graalvm-frameworks --s3-bucket aws-lambda-comparison --capabilities CAPABILITY_IAM



