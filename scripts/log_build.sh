#!/bin/bash
# Build Logging Script
# Logs build outputs with timestamps

LOG_DIR="/root/values-matchmaking-app/logs"
LOG_FILE="${LOG_DIR}/build.log"
BUILD_DATE=$(date +%Y-%m-%d)
BUILD_TIME=$(date +%H:%M:%S)

mkdir -p "$LOG_DIR"

# Log build start
echo "[${BUILD_DATE} ${BUILD_TIME}] Build Started" >> "$LOG_FILE"

# Run build and capture output
/root/values-matchmaking-app/scripts/build.sh 2>&1 | while IFS= read -r line; do
    echo "[${BUILD_DATE} ${BUILD_TIME}] $line" >> "$LOG_FILE"
    echo "$line"
done

# Log build end
BUILD_EXIT=${PIPESTATUS[0]}
if [ $BUILD_EXIT -eq 0 ]; then
    echo "[${BUILD_DATE} ${BUILD_TIME}] Build Completed Successfully" >> "$LOG_FILE"
else
    echo "[${BUILD_DATE} ${BUILD_TIME}] Build Failed with exit code $BUILD_EXIT" >> "$LOG_FILE"
fi

# Rotate logs (keep last 30 days)
find "$LOG_DIR" -name "build.log" -mtime +30 -delete

exit $BUILD_EXIT

