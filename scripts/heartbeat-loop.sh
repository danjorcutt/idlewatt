#!/usr/bin/env bash
# Keeps demo nodes online by sending a signed heartbeat for each node ID given,
# every INTERVAL seconds (default 300). Usage: ./heartbeat-loop.sh 2 3 4
set -euo pipefail
cd "$(dirname "$0")"; . ./env.sh
: "${INTERVAL:=300}"
[ $# -gt 0 ] || { echo "usage: $0 <node-id> [node-id...]"; exit 1; }
while true; do
  for id in "$@"; do call Heartbeat "$id" "" >/dev/null && echo "$(date -Is) heartbeat node $id"; done
  sleep "$INTERVAL"
done
