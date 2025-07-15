#!/usr/bin/env python3
import sys
import re

def fix_tufte_structure(html_content):
    """Fix the HTML structure to match post1.html format"""
    
    # Remove the duplicate title section
    html_content = re.sub(
        r'    <div class="center">.*?</div>\s*',
        '',
        html_content,
        flags=re.DOTALL
    )
    
    # Fix section structure
    html_content = re.sub(
        r'<section id="[^"]*" class="level1">',
        '<section>',
        html_content
    )
    
    # Convert h1 to h2 for content sections (but not the main title)
    html_content = re.sub(
        r'    <h1 id="[^"]*">([^<]+)</h1>',
        r'      <h2>\1</h2>',
        html_content
    )
    
    # Also catch h1 without id
    html_content = re.sub(
        r'    <h1>([^<]+)</h1>',
        r'      <h2>\1</h2>',
        html_content
    )
    
    # Fix indentation for sections
    html_content = re.sub(
        r'    <section>',
        r'    <section>',
        html_content
    )
    
    # Ensure proper closing
    if not html_content.endswith('</article>\n</body>\n</html>'):
        html_content = re.sub(
            r'  </article>\s*</body>\s*</html>\s*$',
            '  </article>\n</body>\n</html>',
            html_content
        )
    
    return html_content

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 fix-tufte-structure.py <html-file>")
        sys.exit(1)
    
    filename = sys.argv[1]
    
    with open(filename, 'r', encoding='utf-8') as f:
        content = f.read()
    
    fixed_content = fix_tufte_structure(content)
    
    with open(filename, 'w', encoding='utf-8') as f:
        f.write(fixed_content)
    
    print(f"Fixed structure for {filename}")