#!/bin/bash

pathlec="./Lectures-lyx"
destlec="./Lectures-pdf"

pathtut="./Tutorials-lyx"
desttut="./Tutorials-pdf"

format="pdf2"
ext="pdf"

lecfiles=`ls $pathlec | grep -v \~ | grep -v ^[1-9] | cut -d"." -f1 | uniq`
tutfiles=`ls $pathtut | grep -v \~ | grep -v ^[1-9] | cut -d"." -f1 | uniq`
echo $tutfiles

make_lectures() {
    for f in $lecfiles
    do
        lyx -e $format $pathlec/$f.lyx
        mv -f $pathlec/$f.$ext $destlec/
    done
}

make_tutorials() {
    for f in $tutfiles
    do
        lyx -e $format $pathtut/$f.lyx
        mv -f $pathtut/$f.$ext $desttut/
        num=`echo $f | grep -Eo '[0-9]{1,4}'`
        pdfunite $desttut/handout/tutorial${num}_handout.$ext $desttut/$f.$ext $desttut/tutorial_${num}.${ext}
        rm $desttut/$f.$ext
    done
}

make_lectures
make_tutorials