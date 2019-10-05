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
		makeglossaries $FILE_NAME
		pdflatex  $FILE_NAME
		pdflatex  $FILE_NAME
	fi
}

function build_chapter(){
	local JOB_NAME=${FILE_NAME}_${CHAPTER_NAME}
	echo $JOB_NAME
	pdflatex -jobname=$JOB_NAME "\includeonly{$CHAPTER_NAME}\input{$FILE_NAME}"

	if $COMPILE_BIB; then
		bibtex $JOB_NAME
		makeglossaries $JOB_NAME
		pdflatex -jobname=$JOB_NAME "\includeonly{$CHAPTER_NAME}\input{$FILE_NAME}"
		pdflatex -jobname=$JOB_NAME "\includeonly{$CHAPTER_NAME}\input{$FILE_NAME}"
	fi
}

function build_bib(){
	bibtex $FILE_NAME
}

function clean_aux_files(){
	FILES_TO_RM='*.aux *.lof *.log *.lol *.toc *.dvi *.bbl *.blg *.lot *.acn *.acr *.alg *.glsdefs *.ist *.out'
	rm $FILES_TO_RM 2> /dev/null
	echo "All clean"
}

function rename(){
	d=`date +%Y_%m_%d_%H_%M`
	c=`git log -1 --pretty=format:"%h"` 
	name=${FILE_NAME}_${d}_${c}.pdf
	echo $name

	cp ${FILE_NAME}.pdf $name
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
	COMPILE_BIB=true
	build_chapter
elif [[ $1 == 'simple_chapter' ]]; then
	CHAPTER_NAME=$3
	COMPILE_BIB=false
	build_chapter
elif [[ $1 == 'bib' ]]; then
	build_bib
elif [[ $1 == 'clean' ]]; then
	clean_aux_files
elif [[ $1 == 'rename' ]]; then
	rename
else
	echo "unknown command: $1"
fi

