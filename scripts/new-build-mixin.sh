#!/bin/bash

DESCR="New Build Mixin"
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
    echo "Usage: new-build-mixin.sh mixin-name"
    exit
fi

MIXIN=build-${ARGS[0]}-mixin

mkdir $MIXIN
gh repo create -d "$DESCR" --public birc-gsa/$MIXIN
cd $MIXIN
git init

mkdir -p .github/actions/build
cat <<EOT > .github/actions/build/action.yml
name: 'Configure and build'
description: 'Setting up and building the project'
runs:
  using: "composite"
  steps:
    - name:  Configure Makefile
      run:   cmake .
      shell: bash
    - name:  Building project files
      run:   make
      shell: bash
EOT
git add .github/actions/build/action.yml

mkdir -p .github/workflows
cat <<EOT > .github/workflows/build-ci.yml
name: Build CI

on: [push]

jobs:
  make-testing:
    name: Consistency testing from make file
    runs-on: ubuntu-latest
    steps:
      - name: Checking out repository
        uses: actions/checkout@v2

      - name: Building project
        uses: ./.github/actions/build

      - name: Checking
        run:  make test
EOT
git add .github/workflows/build-ci.yml

git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/birc-gsa/$MIXIN.git
git push -u origin main
git commit -am "done setting up mixin"
git push

echo "Now update .github/actions/build/action.yml and .github/workflows/build-ci.yml"
echo "to adjust the workflows to the new build system."
