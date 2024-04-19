#!/bin/sh
# Monthly marine data archive

userROOT=/lfs/h2/emc/obsproc/noscrub/ashley.stanfield

# source modules
. $userROOT/git/fix/moduleload.wc2

# See which monthly tanks are available for archive
yr=$(date +%Y)
mo=$(date +%m)
#for f in $DCOMROOT/prod/${yr}${mo}/b031/* ;
for f in $DCOMROOT/20????/b031/* ;
do
  echo $f ;
done

# Do stuff
#for f in $DCOMROOT/prod/${yr}${mo} ;
for f in $DCOMROOT/20???? ;
do
  ym=$(basename $f)
  yy=$(echo $ym | cut -c1-4)
  mm=$(echo $ym | cut -c5-6)
  echo $ym $yy $mm
  ddir=$userROOT/MarineArchive/dcom_d10/$yy
  for s in $f/b031/* ;
  do
    x=$(basename $s)
    case $(echo $x | cut -c3-5) in
      001) t=bathy ;;
      002) t=tesac ;;
      003) t=trkob ;;
      005) t=subpfl ;;
      006) t=xbtctd ;;
      007) t=altkob ;;
      *) t=other ;;
    esac
    echo $ym $mm $t
    ddmt=${ddir}/${mm}/$t
    echo $ddmt
    [ -d ${ddmt} ] || { echo "mkdir -p ${ddmt}" ; mkdir -p ${ddmt} ; }
    [ -s ${ddmt}/${t}.${ym}.dcom ] || \
      { echo "cp -p $s ${ddmt}/${t}.${ym}.dcom" ;
              cp -p $s ${ddmt}/${t}.${ym}.dcom  ; }
    [ -s ${ddmt}/${t}.${ym}.dcom  ] && \
      { [ -s ${ddmt}/${t}.${ym}.dcom.gz ] && \
          { echo "/bin/rm -f ${ddmt}/${t}.${ym}.dcom.gz" ;
                  /bin/rm -f ${ddmt}/${t}.${ym}.dcom.gz  ; }
        echo "gzip  ${ddmt}/${t}.${ym}.dcom" ;
              gzip  ${ddmt}/${t}.${ym}.dcom  ;
      }
  done   # for s
done  # for f

exit

