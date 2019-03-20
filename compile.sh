#!/bin/bash

FILE_NAME=$1

echo $FILE_NAME

latex  $FILE_NAME.tex
if [[ $2 == 'b' ]]; then
	bibtex $FILE_NAME
	latex  $FILE_NAME.tex
	latex  $FILE_NAME.tex
fi
dvipdfm $FILE_NAME.dvi
