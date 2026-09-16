#!/usr/bin/env bash

ZOOM_DIR="$HOME/.cache/niri"
ZOOM_FILE="$ZOOM_DIR/overview-zoom.kdl"

mkdir -p "$ZOOM_DIR"

# 1. Force the extreme zoom-out
echo "overview { zoom 0.2; }" > "$ZOOM_FILE"

sleep 0.2

# 2. Trigger the overview animation
niri msg action toggle-overview

while read -r line; do
  if [[ "$line" == *"\"OverviewAction\":\"Close\""* ]]; then
    break
  fi
done < <(niri msg --json event-stream)
