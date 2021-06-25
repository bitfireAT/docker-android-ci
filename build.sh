#!/bin/sh

IMAGE=registry.gitlab.com/bitfireat/docker-android-emulator .

docker build --compress -t $IMAGE . && docker push $IMAGE

