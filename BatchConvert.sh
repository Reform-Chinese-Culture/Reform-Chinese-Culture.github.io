#!/bin/bash

# BatchConvert.sh - Converts all tex files to html and pdf using the conversion program

./assets/conversion_sh/htmlBatchConvert.sh && ./assets/conversion_sh/pdfBatchConvert.sh

rm -rf aux/

cp assets/output/index.html index.html

echo "Batch conversion to HTML and PDF complete! Folder aux/ removed!"