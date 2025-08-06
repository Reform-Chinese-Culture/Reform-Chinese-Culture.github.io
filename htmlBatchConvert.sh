#!/bin/bash

# htmlBatchConvert.sh - Converts all tex files to HTML using the conversion program

for tex_file in *.tex; do
    if [ -f "$tex_file" ]; then
        # Get the base name without extension
        base_name=$(basename "$tex_file" .tex)
        html_file="${base_name}.html"
                
        # Run the conversion program with tex file and html file as arguments
        ./tex2html.sh "$tex_file" "$html_file"
        
        if [ $? -eq 0 ]; then
            echo ""
        else
            echo "Failed to convert $tex_file"
        fi
    fi
done

echo "Batch conversion complete!"