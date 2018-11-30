#!/bin/bash
SOURCE=$1
GIF=$2
STILL=$3
STILLTIME=$4

WORKDIR=`mktemp -d`

ls $SOURCE | while read line ; do
	ext=${line##*.}
	fname=`basename $line .$ext`
	basefile="$1$line"
	gifname="$2$fname.gif"
	stillname="$3$fname.jpg"
	palettename="$WORKDIR/$fname.png"
	echo $basefile
	echo $gifname
	echo $stillname
	echo $palettename	

	echo "Creating palette"
	ffmpeg -y -ss 2 -t 0.5 -i $basefile -vf fps=15,scale=320:-1:flags=lanczos,palettegen $palettename
	echo "Creating gif"
	ffmpeg -y -ss 2 -t 0.5 -i $basefile -i $palettename -filter_complex "fps=15,scale=720:-1:flags=lanczos[x];[x][1:v]paletteuse" $gifname
	echo "Creating still"
	ffmpeg -y -ss $STILLTIME -i $basefile -t 3 -f image2 $stillname

done;

