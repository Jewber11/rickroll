#!/bin/bash

# Rick Astley in your Terminal - Cleaned Version - Adapted from https://github.com/keroserene/rickrollrc/tree/master
version='1.2'
rick='https://keroserene.net/lol'
video="$rick/astley80.full.bz2"

red='\x1b[38;5;9m'
yell='\x1b[38;5;216m'
green='\x1b[38;5;10m'
purp='\x1b[38;5;171m'

echo -en '\x1b[s'  # Save cursor position.

# Function to check if a command exists
has?() { hash "$1" 2>/dev/null; }

# Clean up on script exit
cleanup() { echo -e "\x1b[2J \x1b[0H ${purp}<3 \x1b[?25h \x1b[u \x1b[m"; }

trap cleanup EXIT  # Ensure cleanup runs on exit

# Function to download files using curl or wget
obtainium() {
  if has? curl; then
    curl -s "$1"
  elif has? wget; then
    wget -q -O - "$1"
  else
    echo "Cannot download the video. Please install curl or wget." && exit 1
  fi
}

# Clear the screen and hide the cursor
echo -en "\x1b[?25l \x1b[2J \x1b[H"

# Fetch and stream the ANSI video
python3 <(cat <<EOF
import sys
import time

fps = 25
time_per_frame = 1.0 / fps
buffer = ''
frame = 0
start_time = time.time()

try:
    for i, line in enumerate(sys.stdin):
        if i % 32 == 0:
            frame += 1
            sys.stdout.write(buffer)
            buffer = ''
            elapsed = time.time() - start_time
            delay = (frame * time_per_frame) - elapsed
            if delay > 0:
                time.sleep(delay)
        buffer += line
except KeyboardInterrupt:
    pass
EOF
) < <(obtainium "$video" | bunzip2 -q 2>/dev/null)

# End of script
