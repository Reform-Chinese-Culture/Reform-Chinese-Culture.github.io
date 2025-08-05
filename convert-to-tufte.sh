#!/bin/bash

# Pandoc command to convert LaTeX to Tufte-styled HTML
# Usage: ./convert-to-tufte.sh input.tex output.html

INPUT=${1:-index.tex}
OUTPUT=${2:-index.html}

# Extract title and subtitle from LaTeX file, handling nested braces
EXTRACTED_TITLE=$(grep -o '\\doctitle{.*}' "$INPUT" | sed 's/\\doctitle{\(.*\)}/\1/' | head -1)
EXTRACTED_SUBTITLE=$(grep -o '\\docsubtitle{.*}' "$INPUT" | sed 's/\\docsubtitle{\(.*\)}/\1/' | head -1)
TITLE=${3:-"$EXTRACTED_TITLE"}

# Build metadata arguments
METADATA_ARGS="--metadata title=\"$TITLE\" --metadata pagetitle=\"$TITLE\" --metadata lang=\"en\""
if [ -n "$EXTRACTED_SUBTITLE" ]; then
    METADATA_ARGS="$METADATA_ARGS --metadata subtitle=\"$EXTRACTED_SUBTITLE\""
fi

eval pandoc -s \
  --from latex \
  --to html5 \
  --mathjax \
  --filter pandoc-sidenote \
  --css assets/css/tufte.css \
  --css assets/css/tufte-enhancements.css \
  $METADATA_ARGS \
  --section-divs \
  --wrap=none \
  --columns=65 \
  --template=assets/conversion/tufte-template.html \
  --output="$OUTPUT" \
  "$INPUT"

# Post-process to convert LaTeX formatting in title
sed -i '' 's/\\textit{\([^}]*\)}/<em>\1<\/em>/g' "$OUTPUT"
sed -i '' 's/\\textbf{\([^}]*\)}/<strong>\1<\/strong>/g' "$OUTPUT"

# Post-process to fix heading levels and structure
python3 assets/conversion/fix-tufte-structure.py "$OUTPUT"

echo "Converted $INPUT to $OUTPUT with Tufte styling and post-processed structure"