#!/bin/sh

NAME="$1"
TAG="$2"

NAME="${NAME##/}"
TAG="${TAG##/}"
if [ "$NAME" = "" ] || [ "$TAG" == "" ]; then
  echo "please provide name and tag of the image:"
  echo "./build m4b-tool latest"
else 
  docker build -t "${NAME}:${TAG}" "${NAME}/${TAG}"
  
  if [ "$3" = "run" ]; then
    docker run --network host --name "${NAME}" "${NAME}:${TAG}"
  fi
fi