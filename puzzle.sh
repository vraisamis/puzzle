#!/bin/sh
perl ~/Documents/puzzle/bungei.pl > $1.tex

platex $1.tex
platex $1.tex
dvipdfmx -p b5 $1.dvi
