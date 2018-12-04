# gifbatch
A shell script to batch convert videos to optimized GIFs and create still images using ffmpeg
```
gifbatch.sh usage:
  -i – input files ( eg. video)
  -g – GIF output folder (eg. gif)
  -s – stills output folder (eg. still)
  -t – time index for the still
  -G – time index for the GIF start (see ffmpegs -ss parameter)
  -T – length for the GIF (see ffmpegs -t parameter) 
  -S – gif width in pixels
This script relies on ffmpeg to create the files.
by Merlin Schumacher (mls@ct.de) for c't-Magazin (www.ct.de)
Licensed under the GPLv3
```
