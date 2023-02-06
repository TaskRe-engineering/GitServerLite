#!/bin/bash

#for debugging
#set -ex

while getopts p:t:r:i:c: flag
do
    case "${flag}" in
        p) PORT=${OPTARG};;
        t) DEPLOY_TARGET=${OPTARG};;
        r) RESTART=${OPTARG};;
        i) IMAGE_NAME=${OPTARG};;
        c) CONTAINER_NAME=${OPTARG};;
    esac
done

echo "Cleaning out existing images and containers, if they exist..."
docker stop $CONTAINER_NAME
docker rm $CONTAINER_NAME
docker image rm $IMAGE_NAME

docker build -t $IMAGE_NAME $DEPLOY_TARGET
docker run -d -p $PORT:$PORT --restart $RESTART --name $CONTAINER_NAME $IMAGE_NAME
