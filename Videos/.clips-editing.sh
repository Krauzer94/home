#!/bin/bash

# Rename clips
counter=1
for f in *.mp4; do
    mv "$f" "${counter}.mp4"
    ((counter++))
done

# Rescale to 1080p
for f in *.mp4; do
    ffmpeg -i "$f" -vf "scale=1920:1080" -b:v 6000k "scaled_$f" -y && rm "$f"
done

# Trim and fade
for f in *.mp4; do
    ffmpeg -ss 10 -i "$f" -t 20 \
    -vf 'fade=t=in:st=0:d=1,fade=t=out:st=19:d=1' \
    -af 'afade=t=in:st=0:d=1,afade=t=out:st=19:d=1' \
    -b:v 6000k "edited_"$f -y && rm "$f"
done
