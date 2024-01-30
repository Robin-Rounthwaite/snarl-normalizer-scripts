#!/bin/sh
for x in `cat glacier-restore.txt`
  do
    echo "Begin restoring $x"
    aws s3api restore-object --restore-request "{}" --bucket vg-k8s --key "$x"
    echo "Done restoring $x"
  done