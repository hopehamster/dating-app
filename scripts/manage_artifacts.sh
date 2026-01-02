#!/bin/bash
# Build Artifact Management Script
# Organizes builds by date and cleans up old builds

BUILDS_DIR="/root/values-matchmaking-app/builds"
APK_SOURCE="/root/values-matchmaking-app/build/app/outputs/flutter-apk/app-release.apk"
DATE_DIR=$(date +%Y-%m-%d)
TIMESTAMP=$(date +%H%M%S)

# Create date directory
mkdir -p "${BUILDS_DIR}/${DATE_DIR}"

# Copy APK with timestamp
if [ -f "$APK_SOURCE" ]; then
    cp "$APK_SOURCE" "${BUILDS_DIR}/${DATE_DIR}/app-release-${TIMESTAMP}.apk"
    echo "Artifact saved to ${BUILDS_DIR}/${DATE_DIR}/app-release-${TIMESTAMP}.apk"
else
    echo "ERROR: APK not found at $APK_SOURCE"
    exit 1
fi

# Cleanup old builds (keep last 10 days)
cd "$BUILDS_DIR"
ls -t | tail -n +11 | xargs -r rm -rf
echo "Cleaned up old builds (kept last 10 days)"

