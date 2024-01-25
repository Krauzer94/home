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
    `# Trim 20 seconds` ffmpeg -ss 10 -i $f -t 20 \
    `# Video fade 1sec` -vf 'fade=t=in:st=0:d=1,fade=t=out:st=19:d=1' \
    `# Audio fade 1sec` -af 'afade=t=in:st=0:d=1,afade=t=out:st=19:d=1' \
    `# Output file` 'edited_'$f -y
    rm $f;
done

# Concat text file
for f in edited_*; do echo "file '$f'" >> merge.txt; done

# Merge all clips
ffmpeg -f concat -i merge.txt -c copy video.mp4
