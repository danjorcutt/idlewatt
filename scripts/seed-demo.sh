#!/usr/bin/env bash
# Seeds a freshly deployed IdleWatt realm with SIMULATED demo nodes, heartbeats
# and jobs so the dashboard has something to show. Assumes node IDs 1-4 are
# free (i.e. a fresh deployment). Nothing here talks to Tesla or Akash.
set -euo pipefail
cd "$(dirname "$0")"; . ./env.sh

echo "== registering demo nodes"
call RegisterNode "Tonawanda Cybertruck (simulated)" vehicle "Cybertruck AMD Ryzen MCU + AI4 (simulated)" "US-NY Tonawanda" powershare-backup 35
call RegisterNode "Kenmore RTX 4090 Homenode" home-gpu "RTX 4090 24GB, Ryzen 9 7950X, 64GB" "US-NY Kenmore" grid 45
call RegisterNode "Amherst Solar CPU Box" cpu "Ryzen 7 5800X 8C/16T, 64GB" "US-NY Amherst" solar 6
call RegisterNode "Buffalo Garage RTX 3090" home-gpu "RTX 3090 24GB, i7-12700K, 32GB" "US-NY Buffalo" solar 28

echo "== heartbeats and availability"
call Heartbeat 1 "parked, SoC 78%, plugged in"
call Heartbeat 2 "GPU 38C, 120W idle"
call Heartbeat 3 "solar 3.1kW, 4% load"
call Heartbeat 4 "GPU 41C"
for id in 1 2 3 4; do call SetAvailability "$id" available; done

echo "== simulated jobs"
call RecordJob 2 "llama-3.3-70b inference" 240
call RecordJob 2 "sdxl image batch" 120
call RecordJob 4 "whisper transcription" 180
call RecordJob 3 "embedding batch" 300
call RecordJob 1 "deepseek-v3 inference (sim)" 90

echo "== fairness pool split, then the truck drives off"
call DistributeBonus
call SetAvailability 1 driving
echo "done"
