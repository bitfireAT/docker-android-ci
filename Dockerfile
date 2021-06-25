# This work is licensed under a Creative Commons Public Domain Mark 1.0 License.

FROM openjdk:11-jdk-slim
MAINTAINER Ricki Hirner <hirner@bitfire.at>

# install Debian packages
#   + required for Android SDK (see https://source.android.com/setup/build/initializing)
#   + wget for downloading Android SDK
RUN apt-get update && \
	apt-get install -y --no-install-recommends git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev libgl1-mesa-dev libxml2-utils xsltproc unzip wget && \
	rm -rf /var/lib/apt/lists/* && apt-get clean

ARG VERSION_DOWNLOAD_SDK="25.2.5"
ENV ANDROID_HOME "/sdk"
ENV CMDTOOLS_DIR "${ANDROID_HOME}/cmdline-tools"
ENV CMDTOOLS_LATEST "${ANDROID_HOME}/cmdline-tools/latest"
ENV HOME /root
ENV PATH "${PATH}:${CMDTOOLS_LATEST}/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/emulator"

# install Android SDK
RUN wget -q https://dl.google.com/android/repository/commandlinetools-linux-7302050_latest.zip -O /cmdtools.zip && \
	unzip /cmdtools.zip -d / && \
	mkdir -p ${CMDTOOLS_DIR} && mv /cmdline-tools ${CMDTOOLS_LATEST} && rm -v /cmdtools.zip

ARG VERSION_BUILD_TOOLS="30.0.3"
ARG VERSION_TARGET_SDK="30"
ARG VERSION_EMULATOR_SDK="23"
ARG VERSION_EMULATOR="${VERSION_EMULATOR_SDK};default;x86"

ARG SDK_PACKAGES="tools platform-tools build-tools;${VERSION_BUILD_TOOLS} platforms;android-${VERSION_TARGET_SDK} platforms;android-${VERSION_EMULATOR_SDK} system-images;android-${VERSION_EMULATOR}"

# install SDK components
RUN (while [ 1 ]; do sleep 1; echo y; done) | sdkmanager --verbose ${SDK_PACKAGES}

# create emulator
RUN (while [ 1 ]; do sleep 1; echo n; done) | avdmanager create avd -n test -k "system-images;android-${VERSION_EMULATOR}"

# prepare scripts for emulator control
COPY start-emulator.sh /usr/bin
RUN chmod +x /usr/bin/start-emulator.sh
