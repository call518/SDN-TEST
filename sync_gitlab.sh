#!/bin/bash

if [ "$1X" == "X" ]; then
    echo "Input Comment..... ex) $0 \"test commit\""
    exit
fi

for i in `git status | grep 'deleted:' | awk '{print $NF}'`; do echo "=> git rm $i"; git rm $i; done
git add *
#git commit -m "(Autosync: minor update...)"
git commit -m "$1"
git push
