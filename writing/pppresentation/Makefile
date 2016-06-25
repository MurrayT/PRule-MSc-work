# $URL$
# $Id$
################################################
# Thesis/Dissertation Makefile                 #
#  Joe Foley<foley@mit.edu>                    #
# Based heavily on a Makefile written by       #
#  Daniel Ciaglia 2003                         #
# contact: daniel@sigterm.de                   #
#                                              #
# You (may) need:                              #
#    latex2html  http://www.latex2html.org/    #
################################################

##### Variables #############
#############################

# How many tries before giving up on resolution of references:
TRIES=7

# use the top one to make it automatically duplex.
DUPLEX=-h sty/duplex
#DUPLEX=

# Basename for result
TARGET=presentation
#BIBFILE=${TARGET}.bib
# BIBFILE=references.bib
PROPTARGET=proposal
GRAPHICSDIR=graphics

# Sources
TEXSRC:=$(wildcard *.tex) $(wildcard *.cls) $(wildcard ${GRAPHICSDIR}/*.latex) $(wildcard graphics/*)
EPSSRC:= $(wildcard ${GRAPHICSDIR}/*.eps) $(wildcard Numerical/*.eps)
PDFSRC:= $(wildcard ${GRAPHICSDIR}/*.pdf) $(wildcard Numerical/*.pdf)
TEXINPUTS:=".:./sty//:"

# Programs  -- put absolute paths here if you must
LATEX:=TEXINPUTS=${TEXINPUTS}; export TEXINPUTS; latex
PDFLATEX:=TEXINPUTS=${TEXINPUTS}; export TEXINPUTS; pdflatex -shell-escape
BIBPROG:=biber  # can also be bibtex or bibtex8

# ATTENTION!
# File-extensions to delete recursive from here
EXTENSION=acn acr alg aux bbl bcf blg glo glg gls glsdefs idx ind ilg ist lof log lol lot lox mw nav out run.xml toc sbl slg snm sym

######################################
######################################
##### Targets for main ###############
######################################

#all: graphics ps pdf
all: pdf

ps: ${TARGET}.ps

pdf: ${TARGET}.pdf

dualps: ${TARGET}.ps2

dualpdf: ${TARGET}.pdf2

proposal: ${PROPTARGET}.ps ${PROPTARGET}.pdf

##################################################
##################################################
#graphics:
#	cd ${GRAPHICSDIR}; make all
#	cd Numerical; make all

#tab-labels:
#	./organizebib.pl -l 5 main.bib
#	latex reference-labels.tex
#	dvips -o reference-labels.ps reference-labels.dvi

# HTML
html: ${TEXSRC} ${PDFSRC}
	latex ${TARGET}.tex
	bibtex ${TARGET}
	latex ${TARGET}.tex
	latex2html \
	-short_index -split 3 \
	-dir www -numbered_footnotes -no_footnode \
	-antialias -html_version 4.0 \
	${TARGET}.tex
#	-iso_language DE.DE
# PostScript
.dvi.ps:
	echo "Running dvips"
	dvips ${DUPLEX} -o $@ $<
# Try this if you get output that crashes the printer
	echo "Running ps2ps"
	mv $@ $@.tmp
	ps2ps $@.tmp $@

${TARGET}.pdf: ${TEXSRC} ${PDFSRC}

# Use of lscape breaks pdflatex, so we must use dvips to convert
.tex.pdf:
#make graphics
	${PDFLATEX} $<
#	make index  # not needed if using imakeidx
	# make glossary
	# make biblio
	pdflatex_count=${TRIES} ; \
	while egrep -s 'Rerun (LaTeX|to get cross-references right)' $(<:.tex=.log) && [ $$pdflatex_count -gt 0 ] ;\
	    do \
	      echo "Rerunning latex...." ;\
	      ${PDFLATEX} ${TARGET}.tex ;\
	      pdflatex_count=`expr $$pdflatex_count - 1` ;\
	    done

#.dvi.pdf:
#	dvips -Ppdf -tletterSize -G0 -f $< \
#	| gs -dSAFER -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sPAPERSIZE=letter\
#	 -dPDFSETTINGS=/printer -sOutputFile=$@ -dEmbedAllFonts=true\
#	 -dSubsetFonts=true -dMaxSubsetPct=100 -dCompatibilityLevel=1.3 -c save pop -;

# dependancy so that changing a file will result in remaking the document
${TARGET}.dvi: ${TEXSRC} ${EPSSRC}

.tex.dvi:
#	make graphics
	echo "TEXINPUTS:  ${TEXINPUTS}"
	echo "Running latex"
	${LATEX} $<
	make index
	# make glossary
	make biblio
	echo "Rerunning latex...."
	${LATEX} $<
	latex_count=${TRIES} ;\
	while egrep -s 'Rerun (LaTeX|to get cross-references right)' $(<:.tex=.log) && [ $$latex_count -gt 0 ] ;\
	    do \
	      echo "Rerunning latex...." ;\
	      ${LATEX} $<\
	      latex_count=`expr $$latex_count - 1` ;\
	    done


# manual generating glossary
biblio:
	echo "Running ${BIBPROG} on ${TARGET}"
	${BIBPROG} ${TARGET}
glossary:
#echo "Running makeindex(glossary) on ${TARGET}"
# traditional glossary
#makeindex -t ${TARGET}.glg -o ${TARGET}.gls -s mainglossary.gst ${TARGET}.glo
# makeglos
#	makeindex -o ${TARGET}.gls -s makeglos.sty makeglos.glo
	echo "Running makeglossaries on ${TARGET}"
	makeglossaries ${TARGET}
index:
	echo "Running makeindex on ${TARGET}"
	makeindex ${TARGET}.idx


${TARGET}.ps2: ${TARGET}.ps
	psnup -2 -l -d ${TARGET}.ps  ${TARGET}.ps2

# 2on1 PDF
${TARGET}.pdf2: ${TARGET}.ps2
	ps2pdf ${TARGET}.ps2 ${TARGET}.pdf2

viewer:
	evince ${TARGET}.pdf &

#publish:
#	scp main.pdf user@hostname:/var/www/html/Dissertation/
#	scp draft.pdf user@hostname:/var/www/html/Dissertation/

# Clean
clean:
	for EXT in ${EXTENSION}; \
	do \
	find `pwd` -name \*\.$${EXT} -exec rm -v \{\} \; ;\
	done
	rm -f ${TARGET}.{dvi,pdf*,ps*}
	rm -f www/*\.*

tidy:
	for EXT in ${EXTENSION}; \
	do \
	find `pwd` -name \*\.$${EXT} -exec rm -v \{\} \; ;\
	done


.SUFFIXES: .pdf .eps .dot .dvi .tex .ps
