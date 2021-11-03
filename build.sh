#!/bin/sh

IMAGE=registry.gitlab.com/bitfireat/docker-android-emulator .

#docker build --compress --no-cache -t $IMAGE .
docker build --compress -t $IMAGE .


#&& docker push $IMAGE

