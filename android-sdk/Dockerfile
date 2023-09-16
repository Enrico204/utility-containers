FROM docker.io/library/eclipse-temurin:17.0.8.1_1-jdk

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -yq update && \
    apt-get install -yq wget curl unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ARG CMDLINE_TOOLS
RUN wget --progress=dot -O /tmp/sdk-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-${CMDLINE_TOOLS}_latest.zip \
    && unzip -d /tmp/ /tmp/sdk-tools.zip \
    && mkdir -p /opt/android-sdk/cmdline-tools/ \
    && mv /tmp/cmdline-tools /opt/android-sdk/cmdline-tools/latest \
    && rm /tmp/sdk-tools.zip

ENV ANDROID_HOME=/opt/android-sdk/
ENV ANDROID_SDK_ROOT=/opt/android-sdk/
ENV PATH="/opt/android-sdk/cmdline-tools/latest/bin:${PATH}"

RUN sdkmanager --update

RUN yes | sdkmanager --licenses

ARG BUILD_TOOLS
ARG ANDROID_SDK
RUN yes | sdkmanager "platform-tools" "build-tools;${BUILD_TOOLS}" "platforms;android-${ANDROID_SDK}"

RUN yes | sdkmanager --licenses

ENV PATH="/opt/android-sdk/emulator:/opt/android-sdk/build-tools/${BUILD_TOOLS}:/opt/android-sdk/platform-tools:/opt/android-sdk/tools:${PATH}"
