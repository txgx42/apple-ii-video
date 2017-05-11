#!/bin/sh

INFILE=$1
B2D="buckshot-dist-linux/b2d"

ffmpeg -i ${INFILE} -r 12 -f image2 %05d.png
for file in `ls *.bmp`; do ${B2D} $file hgr d9; done
perl makemovie.pl

