#!/bin/bash

for i in `git status | grep 'deleted:' | awk '{print $NF}'`; do echo "=> git rm $i"; git rm $i; done
git add *
git commit -m "update something... (run sync_gitlab.sh)"
git push
