#!/bin/bash

DESCR="Exercise"
ARGS=()
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -d|--description)
      shift
      DESCR=$1
      shift
      ;;
    *)
      ARGS+=("$1") # save it in an array for later
      shift
      ;;
  esac
done

if (( ${#ARGS[@]} != 1 )); then
    echo "Usage: new-exercise.sh repo-name"
    exit
fi

PROJ=${ARGS[0]}

mkdir $PROJ
gh repo create -d "$DESCR" --public birc-gsa/$PROJ
cd $PROJ
git init
echo "#" $DESCR > README.md
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/birc-gsa/$PROJ.git
git push -u origin main
git commit -am "done setting up exercise"
git push
