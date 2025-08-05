#!/bin/bash

# Batch convert all .tex files to .html using tex2html.sh
# Usage: ./batch-tex2html.sh

echo "Starting batch conversion of all .tex files to .html..."

# Find all .tex files in the current directory
for tex_file in *.tex; do
    # Check if any .tex files exist
    if [ ! -e "$tex_file" ]; then
        echo "No .tex files found in current directory"
        exit 1
    fi
    
    # Get the base name without extension
    base_name=$(basename "$tex_file" .tex)
    
    # Set output HTML file name
    html_file="${base_name}.html"
    
    # Set title based on filename (capitalize first letter)
    title=$(echo "$base_name" | sed 's/^./\U&/')
    
    echo "Converting $tex_file to $html_file..."
    
    # Call tex2html.sh with the current file
    ./assets/conversion/tex2html.sh "$tex_file" "$html_file" "$title"
    
    if [ $? -eq 0 ]; then
        echo "✓ Successfully converted $tex_file to $html_file"
    else
        echo "✗ Failed to convert $tex_file"
    fi
    
    echo ""
done

echo "Batch conversion completed!"