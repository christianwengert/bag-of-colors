#!/bin/bash
#
# This script is the one that has been used to generate the small images from original jpg images
#
# cd /tmp
# wget http://pascal.inrialpes.fr/data/holidays/jpg1.tar.gz
# wget http://pascal.inrialpes.fr/data/holidays/jpg2.tar.gz
# tar -zxvf jpg1.tar.gz --directory=/tmp/holidays; 
# tar -zxvf jpg2.tar.gz --directory=/tmp/holidays
#

dirroot=/tmp/holidays

nbpix=$[128*128]

for infile in `find ${dirroot}/jpg -name "*.jpg"` ; do

  bname=`basename $infile .jpg`
  outfile=${dirroot}/ppmsmall/${nbpix}pix/${bname}.ppm

  echo "$infile -> $outfile"

  # Rescaling and intensity normalization
  djpeg $infile | pnmnorm -bpercent=0.01 -wpercent=0.01 -maxexpand=400 | pamscale -pixels $nbpix > $outfile
done
