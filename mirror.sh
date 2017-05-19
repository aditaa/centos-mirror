#!/bin/bash

source /etc/mirror_config
RSYNC_RETVAL=1

# Number of arguments should be at least 1
if [ "$1" != "centos" ] && [ "$1" != "epel" ]; then
  echo "Usage: $0 [centos / epel]"
  exit 1
fi

if [ -f $LOCK_FILE_$1 ]; then
  echo "CentOS updates via rsync already running."
  echo "please remove $LOCK_FILE_$1"
  exit 0
fi

if [ "$1" == "centos" ]; then
  MIRROR=$CENTOS_MIRROR
elif [ "$1" == "epel" ]; then
  MIRROR=$EPEL_MIRROR
else
  echo "Usage: $0 [centos / epel]"
  exit 1
fi


echo "Starting $1 rsync from $MIRROR to $TARGET_DIR/$1..."

touch $LOCK_FILE_$1
# add --exclude as necessary

rsync  -avSHP --delete --exclude-from=$1_exclude --numeric-ids --delete-after $MIRROR $TARGET_DIR/$1
RSYNC_RETVAL=$?

/bin/rm -f $LOCK_FILE_$1

if [ $RSYNC_RETVAL -eq 0 ]; then
  echo "Finished $1 rsync from $MIRROR to $TARGET_DIR/$1."
fi

exit 0
