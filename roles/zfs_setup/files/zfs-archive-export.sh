#!/bin/bash
POOL="$1"  # e.g., zarchive-4 or zarchive-5

# Check if pool is imported
if ! zpool list "$POOL" &>/dev/null; then
    echo "Pool $POOL is not imported."
    exit 1
fi

# Check for running syncoid jobs
if pgrep -f "syncoid.*$POOL" >/dev/null; then
    echo "Syncoid replication is running for $POOL. Waiting for it to finish..."
    # Optionally: sleep or prompt user to abort/continue
    while pgrep -f "syncoid.*$POOL" >/dev/null; do
        sleep 5
    done
fi

# Pause syncoid timer if both drives are not present
OTHER_POOL=""
if [ "$POOL" = "zarchive-4" ]; then
    OTHER_POOL="zarchive-5"
else
    OTHER_POOL="zarchive-4"
fi

if ! zpool list "$OTHER_POOL" &>/dev/null; then
    systemctl stop syncoid-archive.timer
    echo "Paused syncoid timer because both drives are not present."
fi

# Export the pool
zpool export "$POOL"
echo "Pool $POOL exported. Safe to unplug."
