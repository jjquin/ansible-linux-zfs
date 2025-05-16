#!/bin/bash
# Try to import both pools; only succeed for plugged-in devices

for pool in zarchive-4 zarchive-5; do
    if ! zpool list "$pool" &>/dev/null; then
        zpool import "$pool" && echo "Imported $pool"
    fi
done

# Resume syncoid timer if at least one pool is present
if zpool list zarchive-4 &>/dev/null || zpool list zarchive-5 &>/dev/null; then
    systemctl start syncoid-archive.timer
    echo "Syncoid timer resumed."
fi

echo "Archive drive(s) online."
