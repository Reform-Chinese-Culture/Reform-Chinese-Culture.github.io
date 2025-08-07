#!/bin/bash

# tex2html_bib.sh - Convert LaTeX to HTML using Option B (LaTeX pre-processing with biblatex)
# Usage: 
#   ./tex2html_bib.sh input.tex output.html  (specify output filename)
#   ./tex2html_bib.sh input.tex              (output will be input.html)

if [ $# -eq 0 ] || [ $# -gt 2 ]; then
    echo "Usage: $0 input.tex [output.html]"
    echo "  If no output file is specified, output will be input.html"
    exit 1
fi

INPUT_FILE="$1"

# Determine output file
if [ $# -eq 2 ]; then
    OUTPUT_FILE="$2"
else
    # Remove .tex extension and add .html
    OUTPUT_FILE="${INPUT_FILE%.tex}.html"
fi

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file '$INPUT_FILE' not found"
    exit 1
fi

# Check if references.bib exists
if [ ! -f "references.bib" ]; then
    echo "Error: references.bib not found"
    exit 1
fi

FILENAME=$(basename "$INPUT_FILE" .tex)

echo "Converting '$INPUT_FILE' to '$OUTPUT_FILE' using Option B (LaTeX pre-processing)..."

# Create temporary directory for LaTeX processing
TEMP_DIR=$(mktemp -d)
echo "Using temporary directory: $TEMP_DIR"

# Copy input file to temp directory
cp "$INPUT_FILE" "$TEMP_DIR/"
cp "references.bib" "$TEMP_DIR/"

# Copy style files if they exist
if [ -d "assets/sty" ]; then
    mkdir -p "$TEMP_DIR/assets/sty"
    cp -r assets/sty/* "$TEMP_DIR/assets/sty/"
fi

# Change to temp directory
cd "$TEMP_DIR"

echo "Step 1: Compiling LaTeX with biblatex-chicago..."

# Run LaTeX compilation sequence to process bibliography
lualatex --interaction=nonstopmode "$FILENAME.tex"
if [ $? -ne 0 ]; then
    echo "✗ First LaTeX compilation failed"
    cd - > /dev/null
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Run biber to process bibliography
echo "Step 2: Processing bibliography with biber..."
biber "$FILENAME"
if [ $? -ne 0 ]; then
    echo "✗ Biber processing failed"
    cd - > /dev/null
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Run LaTeX again to resolve citations
echo "Step 3: Final LaTeX compilation..."
lualatex --interaction=nonstopmode "$FILENAME.tex"
if [ $? -ne 0 ]; then
    echo "✗ Final LaTeX compilation failed"
    cd - > /dev/null
    rm -rf "$TEMP_DIR"
    exit 1
fi

# Change back to original directory
cd - > /dev/null

echo "Step 4: Converting processed LaTeX to HTML..."

# Convert the processed .tex file but also include bibliography processing
pandoc "$TEMP_DIR/$FILENAME.tex" \
  --from latex \
  --to html5 \
  --standalone \
  --citeproc \
  --bibliography "$TEMP_DIR/references.bib" \
  --csl https://www.zotero.org/styles/chicago-fullnote-bibliography \
  --filter pandoc-sidenote \
  --lua-filter assets/filters/reform-filter.lua \
  --css assets/css/tufte.css \
  --css assets/css/tufte_extra.css \
  --template assets/templates/tufte-template.html \
  --variable filename="$FILENAME" \
  --output "$OUTPUT_FILE"

# Clean up
if [ $? -eq 0 ]; then
    echo "✓ Conversion complete: '$OUTPUT_FILE'"
    rm -rf "$TEMP_DIR"
else
    echo "✗ Pandoc conversion failed"
    rm -rf "$TEMP_DIR"
    exit 1
fi