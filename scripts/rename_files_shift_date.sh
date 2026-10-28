#!/bin/bash
# Rename files by shifting their embedded dates one day earlier
# Usage: ./rename_files_shift_date.sh <directory>
# Example: ./rename_files_shift_date.sh datafiles/amex

set -uo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <directory>"
    echo "Example: $0 datafiles/amex"
    exit 1
fi

TARGET_DIR="$1"

if [[ ! -d "$TARGET_DIR" ]]; then
    echo "Error: Directory '$TARGET_DIR' does not exist"
    exit 1
fi

# Counter for renamed files
renamed_count=0
skipped_count=0

# Iterate over all files in the directory
while IFS= read -r -d '' filename; do
    basename=$(basename "$filename")
    
    # Extract date in YYYY-MM-DD format using regex
    if [[ $basename =~ ([0-9]{4})-([0-9]{2})-([0-9]{2}) ]]; then
        original_date="${BASH_REMATCH[1]}-${BASH_REMATCH[2]}-${BASH_REMATCH[3]}"
        
        # Calculate date one day earlier using date command
        # Note: Requires GNU date (available on Linux, macOS with coreutils)
        if ! new_date=$(date -d "$original_date - 1 day" "+%Y-%m-%d" 2>/dev/null); then
            echo "Warning: Could not calculate date for $basename (date: $original_date)"
            ((skipped_count++))
            continue
        fi
        
        # Replace the date in the filename
        new_basename="${basename//$original_date/$new_date}"
        
        # Only rename if the filename changed
        if [[ "$basename" != "$new_basename" ]]; then
            old_path="$TARGET_DIR/$basename"
            new_path="$TARGET_DIR/$new_basename"
            
            # Avoid overwriting existing files
            if [[ -e "$new_path" ]]; then
                echo "Skipped: $basename -> $new_basename (target already exists)"
                ((skipped_count++))
                continue
            fi
            
            mv "$old_path" "$new_path"
            echo "Renamed: $basename -> $new_basename"
            ((renamed_count++))
        fi
    else
        ((skipped_count++))
    fi
done < <(find "$TARGET_DIR" -maxdepth 1 -type f -print0)

echo ""
echo "Summary: $renamed_count file(s) renamed, $skipped_count file(s) skipped"
