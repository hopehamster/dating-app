#!/bin/bash
export ANDROID_HOME=/root/android-sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:/root/flutter/bin
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

cd /root/values-matchmaking-app
/root/flutter/bin/flutter test

