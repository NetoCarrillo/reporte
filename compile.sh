#!/bin/bash

FILE_NAME=$2
COMPILE_BIB=false
CHAPTER_NAME=''


function build_from_dvi(){
	latex  $FILE_NAME.tex
	if $COMPILE_BIB; then
		bibtex $FILE_NAME
		latex  $FILE_NAME.tex
		latex  $FILE_NAME.tex
	fi
	
	dvipdfm $FILE_NAME.dvi
}

function build(){
	pdflatex  $FILE_NAME
	if $COMPILE_BIB; then
		bibtex $FILE_NAME
		pdflatex  $FILE_NAME
		pdflatex  $FILE_NAME
	fi
}

function build_chapter(){
	local JOB_NAME=${FILE_NAME}_${CHAPTER_NAME}
	echo $JOB_NAME
	pdflatex -jobname=$JOB_NAME "\includeonly{$CHAPTER_NAME}\input{$FILE_NAME}"
	bibtex $JOB_NAME
	pdflatex -jobname=$JOB_NAME "\includeonly{$CHAPTER_NAME}\input{$FILE_NAME}"
	pdflatex -jobname=$JOB_NAME "\includeonly{$CHAPTER_NAME}\input{$FILE_NAME}"
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

if [[ $1 == 'all' ]]; then
	COMPILE_BIB=true
	build
elif [[ $1 == 'simple' ]]; then
	COMPILE_BIB=false
	build
elif [[ $1 == 'chapter' ]]; then
	CHAPTER_NAME=$3
	build_chapter
elif [[ $1 == 'bib' ]]; then
	build_bib
elif [[ $1 == 'clean' ]]; then
	clean_aux_files
else
	echo "unknown command: $1"
fi

