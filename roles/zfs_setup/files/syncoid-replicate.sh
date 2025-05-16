#!/bin/bash
# Replicate to whichever archive pool is imported

# List your pools here
POOLS=("zarchive-4" "zarchive-5")

# Find which pool is imported
for pool in "${POOLS[@]}"; do
    if zpool list "$pool" &>/dev/null; then
        archive_pool="$pool"
        break
    fi
done

if [ -z "$archive_pool" ]; then
    echo "No archive pool found! Aborting replication."
    exit 1
fi

# Example: replicate zroot/data to archive pool
syncoid --recursive --skip-parent zroot/data "$archive_pool/backup/$(hostname)/data"
