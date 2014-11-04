#!/bin/bash

for i in `git status | grep 'deleted:' | awk '{print $2}'`; do git rm $i; done
git add *
git commit -m "update something... (run sync_gitlab.sh)"
git push
