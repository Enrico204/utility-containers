FROM docker.io/library/eclipse-temurin:11.0.12_7-jdk

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y wget curl unzip && rm -rf /var/cache/apt/*

RUN wget --progress=dot -O /tmp/sdk-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip \
    && unzip -d /tmp/ /tmp/sdk-tools.zip \
    && mkdir -p /opt/android-sdk/cmdline-tools/ \
    && mv /tmp/cmdline-tools /opt/android-sdk/cmdline-tools/latest \
    && rm /tmp/sdk-tools.zip

ENV ANDROID_HOME=/opt/android-sdk/
ENV ANDROID_SDK_ROOT=/opt/android-sdk/
ENV PATH="/opt/android-sdk/cmdline-tools/latest/bin:${PATH}"

RUN sdkmanager --update

RUN yes | sdkmanager --licenses

RUN yes | sdkmanager "tools" "platform-tools" "build-tools;31.0.0" \
    "platforms;android-30" "platforms;android-31" "cmdline-tools;5.0"

RUN yes | sdkmanager --licenses

ENV PATH="/opt/android-sdk/emulator:/opt/android-sdk/build-tools/30.0.3:/opt/android-sdk/platform-tools:/opt/android-sdk/tools:${PATH}"
