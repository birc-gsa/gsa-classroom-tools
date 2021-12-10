#!/bin/bash

RUN=0
ARGS=()
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -r|--run)
      RUN=1
      shift
      ;;
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

if (( $RUN == 0 )); then
    DO=echo
else
    DO=
fi

#echo $PROJ $MIXIN
$DO mkdir $MIXED
$DO gh repo create -d "GSA project" --public birc-gsa/$MIXED 
$DO cd $MIXED
$DO git init
$DO touch .setup
$DO git add .setup
$DO git commit -m "first commit"
$DO git branch -M main
$DO git remote add origin https://github.com/birc-gsa/$MIXED.git
$DO git push -u origin main
$DO git remote add proj https://github.com/birc-gsa/$PROJ.git
$DO git fetch proj
$DO git merge proj/main --allow-unrelated-histories
$DO git remote add build https://github.com/birc-gsa/$MIXIN.git
$DO git fetch build
$DO git merge build/main --allow-unrelated-histories
$DO rm .setup
$DO git commit -am "done with mixing project and build"
$DO git push
