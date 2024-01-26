#!/bin/bash
# Rename counter
counter=1

# Rename clips
for f in *.mp4; do
    mv "$f" "${counter}.mp4"
    ((counter++))
done

# Trim and fade
for f in *.mp4; do
    `# Rescale to 720p` ffmpeg -i $f -vf "scale=1280:720" \
    `# Output file` 'scaled_'$f -y
    rm $f;
done
