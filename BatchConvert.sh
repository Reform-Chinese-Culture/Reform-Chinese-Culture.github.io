#!/bin/bash

# BatchConvert.sh - Converts all tex files to html using the conversion program

for tex_file in *.tex; do
    if [ -f "$tex_file" ]; then
        # Get the base name without extension
        base_name=$(basename "$tex_file" .tex)
        html_file="${base_name}.html"
        
        echo "Converting $tex_file to $html_file..."
        
        # Run the conversion program with tex file and html file as arguments
        ./tex2html.sh "$tex_file" "$html_file"
        
        if [ $? -eq 0 ]; then
            echo "Successfully converted $tex_file"
        else
            echo "Failed to convert $tex_file"
        fi
    fi
done

echo "Batch conversion complete!"