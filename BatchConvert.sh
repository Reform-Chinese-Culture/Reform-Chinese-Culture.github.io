#!/bin/bash

# BatchConvert.sh - Converts all tex files to html and pdf using the conversion program

./htmlBatchConvert.sh && ./pdfBatchConvert.sh

rm -rf aux/

echo "Batch conversion to HTML and PDF complete! Folder aux/ removed!"