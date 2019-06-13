# !/bin/bash

pathlec="./Lectures-lyx"
destlec="./Lectures-pdf"

pathtut="./Tutorials-lyx"
desttut="./Tutorials-pdf"

format="pdf2"
ext="pdf"

lecfiles=`ls $pathlec | grep -v \~ | grep -v ^[1-9] | cut -d"." -f1 | uniq`
tutfiles=`ls $pathtut | grep -v \~ | grep -v ^[1-9] | cut -d"." -f1 | uniq`

make_lectures() {
    for f in $lecfiles
    do
        lyx -e $format $pathlec/$f.lyx 2>&1
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

make_merged_lectures() {
    sources=`ls $destlec | grep logic | sort -V`
    dest=`echo $sources Lectures.pdf`
    cd $destlec
    pdfunite $dest
    cd ..
}

make_merged_tutorials() {
    sources=`ls $desttut | grep _ | sort -V`
    dest=`echo $sources Tutorials.pdf`
    cd $desttut
    pdfunite $dest
    cd ..
}

make_lectures
make_tutorials
make_merged_lectures
make_merged_tutorials
