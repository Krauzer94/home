#!/bin/bash

# Rename clips
counter=1
for f in *.mp4; do
    mv "$f" "${counter}.mp4"
    ((counter++))
done

# Trim and fade
for f in *.mp4; do
    ffmpeg -ss 10 -i "$f" -t 20 \
    -vf 'fade=t=in:st=0:d=1,fade=t=out:st=19:d=1' \
    -af 'afade=t=in:st=0:d=1,afade=t=out:st=19:d=1' \
    -b:v 6000k "edited_"$f -y && rm "$f"
done

# Create intermediate
counter=1
for f in *.mp4; do
    ffmpeg -i "$f" -c copy "intermediate_${counter}.ts" && rm "$f"
    ((counter++))
done

# Filename array
files=($(find . -type f -name "*.ts"))
concat_list=$(printf "concat:%s|" "${files[@]}")
concat_list=${concat_list%|}

# Merge all videos
ffmpeg -i "$concat_list" -c copy merged.mp4

# Rescale to 1080p
ffmpeg -i merged.mp4 -vf "scale=1920:1080" -b:v 6000k video.mp4 -y && rm merged.mp4

# Delete intermediates
for f in *.ts; do
    rm "$f"
done
