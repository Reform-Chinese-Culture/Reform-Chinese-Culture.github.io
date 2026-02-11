#!/bin/bash

# ./assets/conversion_sh/pdfBatchConvert.sh - Converts all tex files to PDF using the conversion program

for tex_file in *.tex; do
    if [ -f "$tex_file" ]; then
        # Get the base name without extension
        base_name=$(basename "$tex_file" .tex)
        pdf_file="./assets/output/${base_name}.pdf"
                
        # Run the conversion program with tex file and html file as arguments
        ./assets/conversion_sh/tex2pdf.sh "$tex_file" "$pdf_file"
        
        if [ $? -eq 0 ]; then
            echo ""
        else
            echo "Failed to convert $tex_file"
        fi
    fi
done

rm -rf aux/

echo "PDF Batch conversion complete!"
echo "---"