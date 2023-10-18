#!/bin/bash
# $1 - filename
# $2 - hdbPath
# $3 - table
# bash script/loadTaq.sh /home/jshinonome/Downloads/taq/EQY_US_ALL_NBBO_20230703.gz ./hdb quote

mkfifo /tmp/taq.pipe

if [ ! $# -eq 3 ]
then
  echo "No arguments supplied"
  exit 1
fi

# /home/jshinonome/Downloads/taq/EQY_US_ALL_NBBO_20230703.gz
gzip -cd $1 > /tmp/taq.pipe &

ktrl --start --profile q4 --process read-taq-quote --kargs "-table $3 -hdbPath $2 -gzFilepath $1"

rm /tmp/taq.pipe
