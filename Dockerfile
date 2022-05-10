# This work is licensed under a Creative Commons Public Domain Mark 1.0 License.

FROM openjdk:11-jdk-slim
MAINTAINER Ricki Hirner <hirner@bitfire.at>

# install Debian packages
#   + required for Android SDK
#   + git for CI
#   + wget for downloading Android SDK
#   + zstd for compression
RUN apt-get -qq update && \
	apt-get -qq install -y --no-install-recommends curl git-core libgl1-mesa-dev unzip wget zstd && \
	rm -rf /var/lib/apt/lists/* && apt-get -qq clean

ARG VERSION_DOWNLOAD_SDK="25.2.5"
ENV ANDROID_HOME "/sdk"
ENV ANDROID_SDK_ROOT "/sdk"
ENV CMDTOOLS_DIR "${ANDROID_HOME}/cmdline-tools"
ENV CMDTOOLS_LATEST "${ANDROID_HOME}/cmdline-tools/latest"
ENV HOME /root
ENV PATH "${PATH}:${CMDTOOLS_LATEST}/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/emulator"

WORKDIR $HOME

# install Android SDK
RUN wget -q https://dl.google.com/android/repository/commandlinetools-linux-7302050_latest.zip -O /cmdtools.zip && \
	unzip -q /cmdtools.zip -d / && \
	mkdir -p ${CMDTOOLS_DIR} && mv /cmdline-tools ${CMDTOOLS_LATEST} && rm /cmdtools.zip

ARG VERSION_BUILD_TOOLS="32.0.0"
ARG VERSION_TARGET_SDK="32"
ARG VERSION_EMULATOR_SDK="23"
ARG VERSION_EMULATOR="${VERSION_EMULATOR_SDK};default;x86"

ARG SDK_PACKAGES="tools platform-tools build-tools;${VERSION_BUILD_TOOLS} platforms;android-${VERSION_TARGET_SDK} platforms;android-${VERSION_EMULATOR_SDK} system-images;android-${VERSION_EMULATOR}"

# install SDK components, create emulator, compress big directories to keep image small
RUN (while [ 1 ]; do sleep 1; echo y; done) | sdkmanager ${SDK_PACKAGES}; \
	(while [ 1 ]; do sleep 1; echo; done) | avdmanager create avd -n test -k "system-images;android-${VERSION_EMULATOR}"; \
	(cd /; tar -cf root.tar.zstd -I "zstd -T0 -9" root && rm -rf root && tar -cf sdk.tar.zstd -I "zstd -T0 -9" sdk && rm -rf sdk)

# prepare scripts for emulator control
COPY extract-sdk.sh /usr/bin
COPY start-emulator.sh /usr/bin
RUN chmod +x /usr/bin/extract-sdk.sh /usr/bin/start-emulator.sh

