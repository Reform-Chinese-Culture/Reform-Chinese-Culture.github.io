#!/bin/bash

# Pandoc command to convert LaTeX to Tufte-styled HTML
# Usage: ./convert-to-tufte.sh input.tex output.html

INPUT=${1:-index.tex}
OUTPUT=${2:-index.html}
TITLE=${3:-"Reform Chinese Culture"}

pandoc -s \
  --from latex \
  --to html5 \
  --mathjax \
  --filter pandoc-sidenote \
  --css assets/css/tufte.css \
  --css assets/css/tufte-enhancements.css \
  --metadata pagetitle="$TITLE" \
  --metadata lang="en" \
  --section-divs \
  --wrap=none \
  --columns=65 \
  --template=assets/conversion/tufte-template.html \
  --output="$OUTPUT" \
  "$INPUT"

# Post-process to fix heading levels and structure
python3 assets/conversion/fix-tufte-structure.py "$OUTPUT"

echo "Converted $INPUT to $OUTPUT with Tufte styling and post-processed structure"