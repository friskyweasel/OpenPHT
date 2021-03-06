
ERRORFILE=/xbmc/project/Win32BuildSetup/errormingw
NOPFILE=/xbmc/project/Win32BuildSetup/noprompt
MAKECLEANFILE=/xbmc/project/Win32BuildSetup/makeclean
TOUCH=/bin/touch
RM=/bin/rm
NOPROMPT=0
MAKECLEAN=""
MAKEFLAGS=""

export _WIN32_WINNT=0x0600
export NTDDI_VERSION=0x06000000

function throwerror ()
{
  $TOUCH $ERRORFILE
  echo failed to compile $1
  if [ $NOPROMPT == 0 ]; then
	read
  fi
}

function setfilepath ()
{
  FILEPATH=$1
}

function checkfiles ()
{
  for i in $@; do
  FILE=$FILEPATH/$i
  if [ ! -f $FILE ]; then
    throwerror "$FILE"
    exit 1
  fi
  done
}

# cleanup
if [ -f $ERRORFILE ]; then
  $RM $ERRORFILE
fi

# check for noprompt
if [ -f $NOPFILE ]; then
  $RM $NOPFILE
  NOPROMPT=1
fi

if [ -f $MAKECLEANFILE ]; then
  $RM $MAKECLEANFILE
  MAKECLEAN="clean"
else
  MAKECLEAN="noclean"
fi

if [ $NUMBER_OF_PROCESSORS > 1 ]; then
  MAKEFLAGS=-j`expr $NUMBER_OF_PROCESSORS + $NUMBER_OF_PROCESSORS / 2`
fi

# compile our mingw dlls
echo "################################"
echo "## compiling mingw libs"
echo "## NOPROMPT  = $NOPROMPT"
echo "## MAKECLEAN = $MAKECLEAN"
echo "################################"

echo "##### building ffmpeg dlls #####"
cd /xbmc/lib/ffmpeg/
sh ./build_xbmc_win32.sh $MAKECLEAN
setfilepath /xbmc/system/players/dvdplayer
checkfiles avcodec-53.dll avformat-53.dll avutil-51.dll postproc-52.dll swscale-2.dll avfilter-2.dll swresample-0.dll
echo "##### building of ffmpeg dlls done #####"

# wait for key press
if [ $NOPROMPT == 0 ]; then
  echo press a key to close the window
  read
fi
