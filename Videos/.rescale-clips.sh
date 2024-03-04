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
    ffmpeg -i "$f" -vf "crop=1280:720:0:40" -b:v 6000k "cropped_$f" -y && rm "$f";
done

# Rescale to 1080p
for f in *.mp4; do
    ffmpeg -i "$f" -vf "scale=1920:1080" -b:v 6000k "scaled_$f" -y && rm "$f";
done

# Trim and fade
for f in *.mp4; do
    `# Trim 20 seconds` ffmpeg -ss 10 -i $f -t 20 \
    `# Video fade 1sec` -vf 'fade=t=in:st=0:d=1,fade=t=out:st=19:d=1' \
    `# Audio fade 1sec` -af 'afade=t=in:st=0:d=1,afade=t=out:st=19:d=1' \
    `# Output file` -b:v 6000k 'edited_'$f -y
    rm $f;
done
