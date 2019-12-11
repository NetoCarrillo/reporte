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
	FILES_TO_RM='*.aux *.lof *.log *.lol *.toc *.dvi *.bbl *.blg *.lot *.acn *.acr *.alg *.glsdefs *.ist *.out *.nav *.snm'
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

function pack(){
	d=`date +%Y_%m_%d_%H_%M`
	c=`git log -1 --pretty=format:"%h"` 
	name=package_${d}_${c}
	echo $name

	if [[ -d  "${name}" ]]; then
		rm -r ${name}/ || true
	fi
	mkdir -p ${name}/tesis/images
	cp images/*.eps ${name}/tesis/images/.
	cp images/*.png ${name}/tesis/images/.
	cp portada.pdf ${name}/tesis/.
	cp ape-designpatterns.tex ${name}/tesis/.
	cp apendice.tex ${name}/tesis/.
	cp ape-uml.tex ${name}/tesis/.
	cp capitulo1.tex ${name}/tesis/.
	cp capitulo2.tex ${name}/tesis/.
	cp capitulo3.tex ${name}/tesis/.
	cp capitulo4.tex ${name}/tesis/.
	cp capitulo4-2-1-agent.tex ${name}/tesis/.
	cp capitulo4-2-2-logic.tex ${name}/tesis/.
	cp capitulo4-2-3-persistence.tex ${name}/tesis/.
	cp capitulo4-2-4-files.tex ${name}/tesis/.
	cp capitulo4-2-5-reporter.tex ${name}/tesis/.
	cp capitulo4-2-6-web.tex ${name}/tesis/.
	cp capitulo4-3-cumplimiento.tex ${name}/tesis/.
	cp capitulo5.tex ${name}/tesis/.
	cp datos.tex ${name}/tesis/.
	cp prefacio.tex ${name}/tesis/.
	cp reporte.tex ${name}/tesis/tesis.tex
	cp bibliografia.bib ${name}/tesis/.
	cp reporte.pdf ${name}/tesis.pdf
	cp datos.txt ${name}/.
	cp compile.sh ${name}/tesis/.
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
elif [[ $1 == 'pack' ]]; then
	pack
else
	echo "unknown command: $1"
fi

