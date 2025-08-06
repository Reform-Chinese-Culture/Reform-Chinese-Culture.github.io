#!/bin/bash

# pdfBatchConvert.sh - Converts all tex files to PDF using the conversion program

for tex_file in *.tex; do
    if [ -f "$tex_file" ]; then
        # Get the base name without extension
        base_name=$(basename "$tex_file" .tex)
        pdf_file="${base_name}.pdf"
                
        # Run the conversion program with tex file and html file as arguments
        ./tex2pdf.sh "$tex_file" "$pdf_file"
        
        if [ $? -eq 0 ]; then
            echo ""
        else
            echo "Failed to convert $tex_file"
        fi
    fi
done

rm -rf aux/

echo "Batch conversion to PDF complete! Folder aux/ removed!"