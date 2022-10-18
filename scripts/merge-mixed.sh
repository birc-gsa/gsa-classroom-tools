#!/bin/bash

# ANSI colours
YELLOW="\033[33m"
BLUE="\033[34m"
GREEN="\033[32m"
RED="\033[31m"
RESET="\033[0m"

check_file() {
    local file=$1
    
    if (( $# > 1 )) && [ $2 == "warn" ]; then
        local err_col=${YELLOW}
    else
        local err_col=${RED}
    fi

    if [ -f $file ]; then
        echo -e "\t${GREEN}${file} present${RESET}"
    else
        echo -e "\t${err_col}${file} missing${RESET}"
    fi
}


echo -e "${BLUE}Checking that we have a base project and a language mixin...${RESET}"
if [ -f .gsa/project-base ]; then
    proj=`cat .gsa/project-base`
    proj_url=https://github.com/birc-gsa/$proj.git
    echo -e "\tProject repo: ${GREEN}${proj_url}${RESET}"
else
    echo -e "\t${RED}.gsa/project-base does not exist${RESET}" && exit 1
fi
if [ -f .gsa/build-base ]; then
    build=`cat .gsa/build-base`
    build_url=https://github.com/birc-gsa/$build.git
    echo -e "\tBuild mixin repo: ${GREEN}${build_url}${RESET}"
else
    echo -e "\t${RED}.gsa/build-base does not exist${RESET}" && exit 1
fi

echo -e "${BLUE}Setting up remotes...${RESET}"
! git config remote.proj.url  > /dev/null &&  git remote add proj $proj_url
! git config remote.build.url > /dev/null && git remote add build $build_url


echo -e "${BLUE}Pulling updates from project base...${RESET}"
git fetch proj       > /dev/null
git merge proj/main  > /dev/null

check_file README.md
check_file .github/workflows/classroom.yml 
check_file .github/actions/project-test/action.yml   warn
check_file .github/actions/gsa-test/action.yml       warn
check_file .gsa/gsa-test.yaml                        warn

echo -e "${BLUE}Pulling updates from mixin...${RESET}"
git fetch build       > /dev/null
git merge build/main  > /dev/null

check_file .github/actions/build/action.yml
check_file .github/actions/unit-testing/action.yml

