# .latexmkrc - latexmk configuration for automatic LaTeX compilation
# This file configures latexmk to match your VS Code LaTeX Workshop settings

# Set default LaTeX engine to lualatex
$pdf_mode = 4;  # 4 = lualatex

# Configure lualatex command with same arguments as VS Code
$lualatex = 'lualatex -shell-escape -synctex=1 -interaction=nonstopmode -file-line-error %O %S';

# Set output directory to aux/ (matches VS Code setting)
$out_dir = 'aux';

# Configure biber (bibliography processor)
$biber = 'biber --input-directory=aux --output-directory=aux %O %S';

$lualatex = 'lualatex -shell-escape -synctex=1 -interaction=nonstopmode -file-line-error %O %S';

# Clean up auxiliary files but keep PDF in main directory
# Copy PDF from aux/ to main directory after compilation
# $success_cmd = 'cp aux/%R.pdf .';

# Define which file extensions to clean with latexmk -c
# $clean_ext = 'aux bcf blg fdb_latexmk fls log out run.xml synctex.gz';

# Enable continuous preview mode optimizations
# $preview_continuous_mode = 1;
# $pdf_previewer = 'open -a Preview';  # Use Preview.app on macOS