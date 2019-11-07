#!/bin/sh

IMAGE=registry.gitlab.com/bitfireat/docker-android-emulator .

docker build -t $IMAGE . && docker push $IMAGE

