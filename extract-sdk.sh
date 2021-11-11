#!/bin/bash

echo Extracting SDK and emulator image
(cd / && tar -xaf root.tar.zstd && rm -f root.tar.zstd)
(cd / && tar -xaf sdk.tar.zstd && rm -f sdk.tar.zstd)

