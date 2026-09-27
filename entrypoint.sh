#!/bin/bash
set -e

P4USER="${P4USER:-super}"

chown -R p4:p4 /perforce

if [ ! -f "$P4ROOT/db.counters" ]; then
    echo "No DB found, run setup.sh first..."
    exit 1
else
    echo "Existing Perforce database found."
fi

exec gosu p4 p4d \
    -r "$P4ROOT" \
    -J "$P4JOURNAL" \
    -p "$P4PORT" \
    -L "$P4LOG" \

