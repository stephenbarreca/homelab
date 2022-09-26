#!/bin/bash
# plex directory to be backed up
plexdir="/mnt/nvme/plex/config/Library/Application Support/Plex Media Server"
# exclude cache directory
plexcache="${plexdir}/Cache"

# directory to store the backup
bdir="/mnt/plex/movies/plex-backup"
# backup archive path
bfile="${bdir}/full-backup.bz2"
btmp="${bfile}.tmp"

echo "backing up plex to ${bfile}"

# clean existing temp backup
if [ -f "${btmp}" ]; then
  rm "${btmp}"
fi

# make backup and store at temp location
tar --exclude="${plexcache}" --use-compress-program=lbzip2 -cvf "$btmp" "$plexdir"

echo "rotating existing backups"
if [ -f "${bfile}.2" ]; then
  rm "${bfile}.2"
fi
if [ -f "${bfile}.1" ]; then
  mv "${bfile}.1" "${bfile}.2"
fi
if [ -f "${bfile}" ]; then
  mv "${bfile}" "${bfile}.1"
fi

# rename temp backup
mv "${btmp}" "${bfile}"

echo "backup complete"