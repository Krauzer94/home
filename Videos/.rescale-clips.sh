#!/bin/bash
# Rename counter
counter=1

# Rename clips
for f in *.mp4; do
    mv "$f" "${counter}.mp4"
    ((counter++))
done

# Cropp to fill
for f in *.mp4; do
    ffmpeg -i "$f" -vf "crop=1280:720:0:42" "cropped_$f" -y && rm "$f";
done

# Rescale to 1080p
for f in *.mp4; do
    ffmpeg -i "$f" -vf "scale=1920:1080" "scaled_$f" -y && rm "$f";
done
