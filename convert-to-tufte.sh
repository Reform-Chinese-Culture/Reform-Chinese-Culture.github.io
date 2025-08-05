#!/bin/bash

# Pandoc command to convert LaTeX to Tufte-styled HTML
# Usage: ./convert-to-tufte.sh input.tex output.html

INPUT=${1:-index.tex}
OUTPUT=${2:-index.html}

# Extract title, subtitle, and date from LaTeX file, handling nested braces
EXTRACTED_TITLE=$(grep -o '\\doctitle{.*}' "$INPUT" | sed 's/\\doctitle{\(.*\)}/\1/' | head -1)
EXTRACTED_SUBTITLE=$(grep -o '\\docsubtitle{.*}' "$INPUT" | sed 's/\\docsubtitle{\(.*\)}/\1/' | head -1)
EXTRACTED_DATE=$(grep -o '\\docdate{.*}' "$INPUT" | sed 's/\\docdate{\(.*\)}/\1/' | head -1)
TITLE=${3:-"$EXTRACTED_TITLE"}

# Build metadata arguments
METADATA_ARGS="--metadata title=\"$TITLE\" --metadata pagetitle=\"$TITLE\" --metadata lang=\"en\""
if [ -n "$EXTRACTED_SUBTITLE" ]; then
    METADATA_ARGS="$METADATA_ARGS --metadata subtitle=\"$EXTRACTED_SUBTITLE\""
fi
if [ -n "$EXTRACTED_DATE" ]; then
    METADATA_ARGS="$METADATA_ARGS --metadata date=\"$EXTRACTED_DATE\""
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
sed -i '' 's/\\textemdash{}/—/g' "$OUTPUT"

# Post-process to handle preamble environment - create a separate Python script
cat > /tmp/fix_preamble.py << 'EOF'
import re
import sys

def fix_preamble(content):
    # Look for the preamble markers and extract content between them
    preamble_pattern = r'\\begin\{preamble\}(.*?)\\end\{preamble\}'
    
    def replace_preamble(match):
        preamble_content = match.group(1).strip()
        return f'<div class="preamble">{preamble_content}</div>'
    
    # Replace preamble environment
    content = re.sub(preamble_pattern, replace_preamble, content, flags=re.DOTALL)
    
    return content

if __name__ == "__main__":
    filename = sys.argv[1]
    with open(filename, 'r', encoding='utf-8') as f:
        content = f.read()
    
    content = fix_preamble(content)
    
    with open(filename, 'w', encoding='utf-8') as f:
        f.write(content)
EOF

python3 /tmp/fix_preamble.py "$OUTPUT"

# Post-process to fix heading levels and structure
python3 assets/conversion/fix-tufte-structure.py "$OUTPUT"

echo "Converted $INPUT to $OUTPUT with Tufte styling and post-processed structure"