#!/bin/bash

# tex2pdf.sh - Convert LaTeX to PDF using lualatex with cleanup
# Usage: 
#   ./tex2pdf.sh input.tex output.pdf  (specify output filename)
#   ./tex2pdf.sh input.tex             (output will be input.pdf)

if [ $# -eq 0 ]; then
    echo "Usage: $0 input.tex [output.pdf]"
    echo "  If no output file is specified, output will be input.pdf"
    exit 1
fi

INPUT_FILE="$1"

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file '$INPUT_FILE' not found"
    exit 1
fi

# Get base filename without extension
BASE_NAME=$(basename "$INPUT_FILE" .tex)

# Determine output file
if [ $# -eq 2 ]; then
    OUTPUT_FILE="$2"
    OUTPUT_BASE=$(basename "$OUTPUT_FILE" .pdf)
else
    OUTPUT_FILE="${BASE_NAME}.pdf"
    OUTPUT_BASE="$BASE_NAME"
fi

echo "Converting '$INPUT_FILE' to '$OUTPUT_FILE'..."

# Run lualatex compilation (suppress output)
latexmk -lualatex "$INPUT_FILE" > /dev/null 2>&1

if [ $? -eq 0 ]; then
    # Compilation successful, now clean up aux files
    latexmk -c "$INPUT_FILE" > /dev/null 2>&1
    
    # If output filename is different from input filename, rename the PDF
    if [ "$OUTPUT_BASE" != "$BASE_NAME" ]; then
        mv "${BASE_NAME}.pdf" "$OUTPUT_FILE"
        if [ $? -eq 0 ]; then
            echo "✓ Conversion complete: '$OUTPUT_FILE'"
        else
            echo "✗ Failed to rename PDF to '$OUTPUT_FILE'"
            exit 1
        fi
    else
        echo "✓ Conversion complete: '$OUTPUT_FILE'"
    fi
else
    echo "✗ LaTeX compilation failed"
    exit 1
fi