#!/bin/bash

# ./assets/conversion_sh/tex2html.sh - Convert LaTeX to HTML using pandoc with automatic biblatex detection
# Usage: 
#   ./assets/conversion_sh/tex2html.sh input.tex output.html  (specify output filename)
#   ./assets/conversion_sh/tex2html.sh input.tex              (output will be input.html)

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

# Check if the file uses biblatex-chicago (exclude commented lines, allow whitespace before \usepackage)
if grep -q '^[[:space:]]*\\usepackage\[notes\]{biblatex-chicago}' "$INPUT_FILE"; then
    if ./assets/conversion_sh/tex2html_bib.sh "$INPUT_FILE" "$OUTPUT_FILE" > /dev/null; then
        echo "✓ Converted $INPUT_FILE into html with bib"
    else
        echo "✗ Conversion with bib failed"
        ./assets/conversion_sh/tex2html_bib.sh "$INPUT_FILE" "$OUTPUT_FILE"
        exit 1
    fi
else
    if ./assets/conversion_sh/tex2html_wo_bib.sh "$INPUT_FILE" "$OUTPUT_FILE" > /dev/null; then
        echo "✓ Converted $INPUT_FILE into html without bib"
    else
        echo "✗ Conversion without bib failed"
        ./assets/conversion_sh/tex2html_wo_bib.sh "$INPUT_FILE" "$OUTPUT_FILE"
        exit 1
    fi
fi