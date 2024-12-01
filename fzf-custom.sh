#!/bin/sh

# Default mode and start path
mode="files"
start_path="."

# Parse the arguments
for arg in "$@"; do
    case "$arg" in
        -d) mode="directories" ;;
        -f) mode="files" ;;
        *) start_path="$arg" ;; # Assume the argument is the directory path
    esac
done

# Validate the start path
if [ ! -d "$start_path" ]; then
    echo "Error: '$start_path' is not a valid directory."
    exit 1
fi
find "$1" -type d -path '*/.git' -prune -o -print

# Select based on the mode
if [ "$mode" = "directories" ]; then
    selection=$(find "$start_path" -type d \( -path '*/.git' -o -path '*/.obsidian' \) -prune -o -print | fzf)
elif [ "$mode" = "files" ]; then
    selection=$(find "$start_path" -type f \( -path '*/.git' -o -path '*/.obsidian' \) -prune -o -print | fzf)
fi

# Trim whitespace from the selection
selection=$(echo "$selection" | xargs)

# Check if selection is empty
if [ -z "$selection" ]; then
    echo "No selection made. Exiting."
    exit 0
fi

# Open the selection in nvim
$HOME/.local/bin/lvim "$selection"
