#!/bin/bash

if ! git config remote.base.url > /dev/null; then
    git remote add base https://github.com/birc-gsa/gsa-project-base
fi
git fetch base
git merge base/main

