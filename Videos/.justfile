# Video editing automation scripts

_default:
    just --list

# Edit clips and keep the files
clip:
    #!/bin/bash

    # Rename clips
    counter=1
    for f in *.mp4; do
        mv "$f" "${counter}.mp4"
        ((counter++))
    done

    # Rescale to 1080p
    for f in *.mp4; do
        ffmpeg -i "$f" -vf "scale=1920:1080" -b:v 5000k "scaled_$f" -y && rm "$f"
    done

    # Apply video effects
    apply_effects() {
        # Input and output
        f="$1"
        edited="edited_${f%.*}.${f##*.}"

        # Find video duration
        duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$f")

        # Find the last second
        start=$(awk -v dur="$duration" 'BEGIN { print dur - 1 }')

        # Apply fade effects
        ffmpeg -i "$f" \
        -vf "fade=t=in:st=0:d=1,fade=t=out:st=$start:d=1" \
        -af "afade=t=in:st=0:d=1,afade=t=out:st=$start:d=1" \
        -b:v 5000k "$edited" -y && rm "$f"
    }

    # Edit all videos
    for f in *.mp4; do
        apply_effects "$f"
    done

# Edit clips and cropp the edges
deck:
    #!/bin/bash

    # Rename clips
    counter=1
    for f in *.mp4; do
        mv "$f" "${counter}.mp4"
        ((counter++))
    done

    # Rescale to 1080p
    for f in *.mp4; do
        ffmpeg -i "$f" -vf "scale=1920:1080" -b:v 5000k "scaled_$f" -y && rm "$f"
    done

    # Apply video effects
    apply_effects() {
        # Input and output
        f="$1"
        edited="edited_${f%.*}.${f##*.}"

        # Find video duration
        duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$f")

        # Find the last second
        start=$(awk -v dur="$duration" 'BEGIN { print dur - 1 }')

        # Apply fade effects
        ffmpeg -i "$f" \
        -vf "fade=t=in:st=0:d=1,fade=t=out:st=$start:d=1" \
        -af "afade=t=in:st=0:d=1,afade=t=out:st=$start:d=1" \
        -vf "crop=1920:960:0:60" \
        -b:v 5000k "$edited" -y && rm "$f"
    }

    # Edit all videos
    for f in *.mp4; do
        apply_effects "$f"
    done

# Edit clips and merge all files
video:
    #!/bin/bash

    # Rename clips
    counter=1
    for f in *.mp4; do
        mv "$f" "${counter}.mp4"
        ((counter++))
    done

    # Rescale to 1080p
    for f in *.mp4; do
        ffmpeg -i "$f" -vf "scale=1920:1080" -b:v 5000k "scaled_$f" -y && rm "$f"
    done

    # Apply video effects
    apply_effects() {
        # Input and output
        f="$1"
        edited="edited_${f%.*}.${f##*.}"

        # Find video duration
        duration=$(ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$f")

        # Find the last second
        start=$(awk -v dur="$duration" 'BEGIN { print dur - 1 }')

        # Apply fade effects
        ffmpeg -i "$f" \
        -vf "fade=t=in:st=0:d=1,fade=t=out:st=$start:d=1" \
        -af "afade=t=in:st=0:d=1,afade=t=out:st=$start:d=1" \
        -b:v 5000k "$edited" -y && rm "$f"
    }

    # Edit all videos
    for f in *.mp4; do
        apply_effects "$f"
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
    ffmpeg -i "$concat_list" -c copy video.mp4

    # Delete intermediates
    for f in *.ts; do
        rm "$f"
    done
