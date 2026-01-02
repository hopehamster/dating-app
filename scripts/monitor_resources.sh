#!/bin/bash
# Resource Monitoring Script
# Monitors CPU, RAM, and Disk usage on VPS

LOG_FILE="/root/values-matchmaking-app/logs/resource_monitor.log"
mkdir -p /root/values-matchmaking-app/logs

# Get current timestamp
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Get CPU usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')

# Get Memory usage
MEM_TOTAL=$(free | grep Mem | awk '{print $2}')
MEM_USED=$(free | grep Mem | awk '{print $3}')
MEM_PERCENT=$(awk "BEGIN {printf \"%.1f\", ($MEM_USED/$MEM_TOTAL)*100}")

# Get Disk usage
DISK_USAGE=$(df -h / | tail -1 | awk '{print $5}' | sed 's/%//')

# Log the data
echo "{\"timestamp\":\"$TIMESTAMP\",\"cpu\":\"$CPU_USAGE\",\"memory\":\"$MEM_PERCENT\",\"disk\":\"$DISK_USAGE\"}" >> $LOG_FILE

# Check thresholds and alert if needed
if (( $(echo "$CPU_USAGE > 80" | bc -l) )); then
    echo "ALERT: CPU usage is ${CPU_USAGE}%"
fi

if (( $(echo "$MEM_PERCENT > 80" | bc -l) )); then
    echo "ALERT: Memory usage is ${MEM_PERCENT}%"
fi

if [ "$DISK_USAGE" -gt 80 ]; then
    echo "ALERT: Disk usage is ${DISK_USAGE}%"
fi

