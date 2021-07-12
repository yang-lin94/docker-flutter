FROM ubuntu:21.10

# 前置要求
RUN apt update && apt install -y curl git unzip xz-utils zip libglu1-mesa openjdk-8-jdk wget

# 設置新用戶
RUN useradd -ms /bin/bash developer
USER developer
WORKDIR /home/developer

# 設置系統變量和Android目錄
RUN mkdir -p Android/sdk
ENV ANDROID_SDK_ROOT /home/developer/Android/sdk
RUN mkdir -p .android && touch .android/repositories.cfg

# 設置Android SDK
RUN get -O sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
RUN unzip sdk-tools.zip && rm sdk-tools.zip
RUN mv tools Android/sdk/tools
RUN cd Android/sdk/tools/bin && yes | ./sdkmanager --lincenses
RUN cd Android/sdk/tools/bin && ./sdkmanager "build-tools;29.0.2" "sources;android-29"
ENV PATH "$PATH:/home/deveoper/Android/sdk/platform-tools"

# 下載 flutter SDK
RUN git clone https://github.com/flutter/flutter.git
ENV PATH "$PATH:/home/developer/flutter/bin"

# 檢測flutter
RUN flutter doctor
