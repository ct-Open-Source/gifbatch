#!/bin/sh
#SOURCE=$1
#GIF=$2
#STILL=$3
#STILLTIME=$4

workdir=`mktemp -d`

function help {
	echo "\
gifbatch.sh usage:
  -i – input files ( eg. video/*.mp4)
  -g – GIF output folder (eg. gif)
  -s – stills output folder (eg. sill)
  -t – time index for the still
  -G – time index for the GIF start (see ffmpegs -ss parameter) 
  -T – length for the GIF (see ffmpegs -t parameter) 
  -S – gif width in pixels

This script relies on ffmpeg to create the files.

by Merlin Schumacher (mls@ct.de) for c't-Magazin (www.ct.de)
Licensed under the GPLv3
"
	exit 1 >&2
}

if ! [ -x "$(command -v ffmpeg)" ]; then
	echo 'Error: ffmpeg is not installed.' >&2
	help
fi

while getopts "i:g:s:t:G:T:S:" opt; do
	case $opt in
		i)
			input=$OPTARG
			;;
		g)
			gif=$OPTARG
			;;
		s)
			still=$OPTARG
			;;
		t)
			stilltime=$OPTARG
			;;
		G)
			gifstart=$OPTARG
			;;
		T)
			giftime=$OPTARG
			;;
		S)
			gifsize=$OPTARG
			;;
		\?)
			echo "Invalid option: -$OPTARG" >&2
			help
 			;;
		:)
			echo "Option -$OPTARG requires an argument." >&2
			help
 			;;
		*)	
			help
			;;
	esac
done

if [[ -z $input || -z $gif || -z $still || -z $stilltime || -z $gifstart || -z $giftime || -z $gifsize ]]; then
	echo 'one or more variables are undefined'
	exit 1
fi


for entry in "$input"/*
do
	ext=${entry##*.}
	fname=`basename $entry .$ext`
	basefile="$entry"
	gifname="$gif/$fname.gif"
	stillname="$still/$fname.jpg"
	palettename="$workdir/$fname.png"
	echo $entry
	echo "Creating GIF palette"
	ffmpeg -loglevel panic -y -ss $gifstart -t $giftime -i $basefile -vf fps=15,scale=$gifsize:-1:flags=lanczos,palettegen $palettename
	echo "Creating GIF"
	ffmpeg -loglevel panic -y -ss $gifstart -t $giftime -i $basefile -i $palettename -filter_complex "fps=15,scale=$gifsize:-1:flags=lanczos[x];[x][1:v]paletteuse" $gifname
	echo "Creating still"
	ffmpeg -loglevel panic -y -ss $stilltime -i $basefile -t 1 -f image2 $stillname
done
