#!/bin/bash

# Check if the user provided a directory
if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

# Directory to merge files from
DIR=$1

# Output file
OUTPUT="merged.txt"

# Clear the output file if it already exists
> "$OUTPUT"

# Function to recursively find and merge files
merge_files() {
    local folder=$1

    # Find all files in the directory and its subdirectories
    find "$folder" -type f | while read -r file; do
        # Check if the file is larger than 1MB
        if [ $(stat -c%s "$file") -le 1048576 ]; then
            # Check if the file has a non-human-readable extension
            case "$file" in
                *.png|*.jpg|*.jpeg|*.gif|*.bmp|*.tiff|*.ico|*.svg|*.mp3|*.mp4|*.avi|*.mkv|*.mov|*.flac|*.wav|*.ogg|*.pdf|*.zip|*.rar|*.7z|*.tar|*.gz|*.iso)
                    echo "Skipping ${file#$DIR/} (non-human-readable file)"
                    ;;
                *)
                    # Write the relative path as a header
                    echo "// ${file#$DIR/}" >> "$OUTPUT"
                    # Append the content of the file
                    cat "$file" >> "$OUTPUT"
                    # Add a newline for separation
                    echo -e "\n" >> "$OUTPUT"
                    ;;
            esac
        else
            echo "Skipping ${file#$DIR/} (file is larger than 1MB)"
        fi
    done
}

# Call the function
merge_files "$DIR"

echo "All eligible files have been merged into $OUTPUT"
