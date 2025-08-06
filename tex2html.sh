#!/bin/bash

# tex2html.sh - Convert LaTeX to HTML using pandoc with Tufte styling and sidenotes
# Usage: 
#   ./tex2html.sh input.tex output.html  (specify output filename)
#   ./tex2html.sh input.tex              (output will be input.html)

if [ $# -eq 0 ]; then
    echo "Usage: $0 input.tex [output.html]"
    echo "  If no output file is specified, output will be input.html"
    exit 1
fi

INPUT_FILE="$1"

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file '$INPUT_FILE' not found"
    exit 1
fi

# Determine output file
if [ $# -eq 2 ]; then
    OUTPUT_FILE="$2"
else
    # Remove .tex extension and add .html
    OUTPUT_FILE="${INPUT_FILE%.tex}.html"
fi

echo "Converting '$INPUT_FILE' to '$OUTPUT_FILE'..."

# Extract filename without extension for PDF link
FILENAME=$(basename "$INPUT_FILE" .tex)

# Run pandoc conversion
pandoc "$INPUT_FILE" \
  --from latex \
  --to html5 \
  --standalone \
  --filter pandoc-sidenote \
  --lua-filter assets/filters/reform-filter.lua \
  --css assets/css/tufte.css \
  --css assets/css/tufte_extra.css \
  --template assets/templates/tufte-template.html \
  --variable filename="$FILENAME" \
  --output "$OUTPUT_FILE"

if [ $? -eq 0 ]; then
    echo "✓ Conversion complete: '$OUTPUT_FILE'"
else
    echo "✗ Conversion failed"
    exit 1
fi