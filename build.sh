#!/bin/sh

echo This script is only used to test the Dockerfile locally.
echo The real image is created by Github CI and stored as a Github package.

docker build --compress -t docker-android-ci-test .

