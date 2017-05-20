#!/bin/bash

git checkout master
git pull 
git remote prune origin
git branch --merged master | grep -v 'master$' | xargs git branch -d
echo "The following remote branches are fully merged into master, have no commits for a month and will be removed:" 

for k in $(git branch -r --merged master | grep -v 'master$'); do 
  if [ ! -n "$(git log -1 --since='1 month ago' -s $k)" ]; then
    gitbranch=`echo $k | sed 's/ *origin\///'`  
    echo $gitbranch
    read -p " Delete? (y/n)? " 
    if [ "$REPLY" == "y" ]; then
   	git push --delete origin $gitbranch
	echo "Deleted!"
    fi
  fi
done
