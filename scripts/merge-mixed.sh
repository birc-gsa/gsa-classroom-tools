#!/bin/bash

if ! git config remote.base.url > /dev/null; then
    git remote add base https://github.com/birc-gsa/gsa-project-base
fi
git fetch base
git merge base/main

[ ! -f .gsa/project-base ] && echo ".gsa/project-base does not exist" && exit 1
[ ! -f .gsa/build-base ] && echo ".gsa/build-base does not exist" && exit 1

proj=`cat .gsa/project-base`
build=`cat .gsa/build-base`

if ! git config remote.proj.url > /dev/null; then
    git remote add proj https://github.com/birc-gsa/$proj.git
fi
if ! git config remote.build.url > /dev/null; then
    git remote add build https://github.com/birc-gsa/$build.git
fi

git fetch proj
git merge proj/main
git fetch build
git merge build/main
