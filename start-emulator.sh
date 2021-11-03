#!/bin/bash

# This work is licensed under a Creative Commons Public Domain Mark 1.0 License.
#
# Originally written by Ralf Kistner <ralf@embarkmobile.com>, placed to public domain
# Extended by Ricki Hirner for DAVx5 and other projects

echo Extracting SDK and emulator image
(cd / && tar -xaf root.tar.zstd && rm -f root.tar.zstd)
(cd / && tar -xaf sdk.tar.zstd && rm -f sdk.tar.zstd)

echo Starting headless emulator
(cd /sdk/emulator && ./emulator -no-window -no-snapshot -no-audio -gpu swiftshader_indirect @test &)

echo Waiting for emulator adb
adb wait-for-device

set +e

bootanim=""
failcounter=0
timeout_in_sec=360

until [[ "$bootanim" =~ "stopped" ]]; do
  bootanim=`adb -e shell getprop init.svc.bootanim 2>&1 &`
  if [[ "$bootanim" =~ "device not found" || "$bootanim" =~ "device offline"
    || "$bootanim" =~ "running" ]]; then
    let "failcounter += 1"
    echo "Waiting for emulator to start"
    if [[ $failcounter -gt timeout_in_sec ]]; then
      echo "Timeout ($timeout_in_sec seconds) reached; failed to start emulator"
      exit 1
    fi
  fi
  sleep 3
done

echo "Emulator is ready"
