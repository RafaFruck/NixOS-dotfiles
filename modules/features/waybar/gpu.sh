#!/usr/bin/env zsh
icon="<span size='200%' rise='-5000'>󰢮</span>"
/run/wrappers/bin/intel_gpu_top -J -o - -s 1000 2>/dev/null \
  | jq --unbuffered --stream -c 'select(.[0][1]=="engines" and .[0][2]=="Render/3D" and .[0][3]=="busy") | .[1]' \
  | while read -r busy; do
      LC_NUMERIC=C printf '{"text": "%.0f%% %s", "tooltip": "GPU (Render/3D): %.0f%%"}\n' "$busy" "$icon" "$busy"
    done
