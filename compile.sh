#!/bin/bash

FILE_NAME=$1

echo $FILE_NAME

latex  $FILE_NAME.tex
bibtex $FILE_NAME
latex  $FILE_NAME.tex
latex  $FILE_NAME.tex
dvipdf $FILE_NAME.dvi
