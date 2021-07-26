#!/bin/bash
if [ $# -eq 0 ]
  then
    echo "please provide a torrent number"
    exit 1
fi

for t in $(cat trackers-all.txt )
do
    echo "Adding tracker: $t"
    transmission-remote transmission.local:80 --torrent $1 --tracker-add "${t}"
done
