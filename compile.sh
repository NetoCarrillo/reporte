#!/bin/bash

FILE_NAME=$2
COMPILE_BIB=false
CHAPTER_NAME=''


function build(){
	latex  $FILE_NAME.tex
	if $COMPILE_BIB; then
		bibtex $FILE_NAME
		latex  $FILE_NAME.tex
		latex  $FILE_NAME.tex
	fi
	
	dvipdfm $FILE_NAME.dvi
}

function build_chapter(){
	# latex $FILE_NAME.tex
	# if $COMPILE_BIB; then
	# 	bibtex $FILE_NAME
	# 	for (( i = 0; i < 100; i++ )); do
	# 		echo "$COMPILE_BIB"
	# 		#statements
	# 	done
	# 	latex $FILE_NAME.tex
	# 	latex $FILE_NAME.tex
	# fi
	# pdflatex  $FILE_NAME.tex
	bibtex $CHAPTER_NAME
	pdflatex -jobname=$FILE_NAME_$CHAPTER_NAME "\includeonly{$CHAPTER_NAME}\input{$FILE_NAME}"
}

function build_bib(){
	bibtex $FILE_NAME
}

function clean_aux_files(){
	FILES_TO_RM='*.aux *.lof *.log *.lol *.toc *.dvi *.bbl *.blg *.lot'
	rm $FILES_TO_RM 2> /dev/null
	echo "All clean"
}

echo $FILE_NAME

if [[ $1 == 'c' ]]; then
	[ $3 == 'b' ] && COMPILE_BIB=true
	build
elif [[ $1 == 's' ]]; then
	CHAPTER_NAME=$3
	[ $4 == 'b' ] || COMPILE_BIB=true
	build_chapter
elif [[ $1 == 'b' ]]; then
	build_bib
elif [[ $1 == 'clean' ]]; then
	clean_aux_files
else
	echo "unknown command: $1"
fi

