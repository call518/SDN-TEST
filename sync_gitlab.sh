#!/bin/bash

for i in `git status | grep 'deleted:' | awk '{print $NF}'`; do echo "=> git rm $i"; git rm $i; done
git add *
#git commit -m "(Autosync: minor update...)"
git commit -m "$1"
git push
