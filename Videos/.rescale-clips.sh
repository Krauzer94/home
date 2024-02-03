#!/bin/bash
# Rename counter
counter=1

# Rename clips
for f in *.mp4; do
    mv "$f" "${counter}.mp4"
    ((counter++))
done

# Rescale to 1080p
for f in *.mp4; do
    `# Rescale to 1080p` ffmpeg -i $f -vf "scale=1920:1080" \
    `# Output file` 'scaled_'$f -y
    rm $f;
done
