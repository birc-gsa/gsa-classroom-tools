#!/bin/bash

ARGS=()
while [[ $# -gt 0 ]]; do
  key="$1"

    *)
      ARGS+=("$1") # save it in an array for later
      shift
      ;;
  esac
done

if (( ${#ARGS[@]} != 2 )); then
    echo "Usage: mix-project.sh project build-mixin"
    exit
fi

PROJ=${ARGS[0]}
MIXIN=build-${ARGS[1]}-mixin
MIXED=$PROJ-${ARGS[1]}

mkdir $MIXED
gh repo create -d "GSA project" --public birc-gsa/$MIXED 
cd $MIXED
git init
touch .setup
git add .setup
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/birc-gsa/$MIXED.git
git push -u origin main

mkdir -p .gsa
echo $PROJ > .gsa/project-base
git remote add proj https://github.com/birc-gsa/$PROJ.git
git fetch proj
git merge proj/main --allow-unrelated-histories


echo $MIXIN > .gsa/build-base
git remote add build https://github.com/birc-gsa/$MIXIN.git
git fetch build
git merge build/main --allow-unrelated-histories
rm .setup
git commit -am "done with mixing project and build"
git push
