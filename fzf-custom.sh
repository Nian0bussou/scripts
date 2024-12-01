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

while true; do
    # Select mode for fzf
    if [ "$mode" = "directories" ]; then
        selection=$(find "$start_path" \( -path '*/.git' -o -path '*/.obsidian' \) -prune -o -type d -print | fzf --preview 'cat {} ')
    elif [ "$mode" = "files" ]; then
        selection=$(find "$start_path" \( -path '*/.git' -o -path '*/.obsidian' \) -prune -o -type f -print | fzf --preview 'cat {} ')
    fi

    # Trim whitespace from the selection
    selection=$(echo "$selection" | xargs)

    # Check if selection is empty
    if [ -z "$selection" ]; then
        echo "Exiting fzf."
        break
    fi

    # Open the selection in vim
    $HOME/.local/bin/lvim "$selection"

    # Prompt the user to continue or exit
    echo "Press Enter to return to fzf, or type 'q' to quit:"
    read -r choice
    if [ "$choice" = "q" ]; then
        echo "Exiting."
        break
    fi
done
