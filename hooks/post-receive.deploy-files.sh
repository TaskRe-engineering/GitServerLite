#!/bin/bash

#for debugging
#set -ex

while getopts t:g:b: flag
do
    case "${flag}" in
        t) TARGET=${OPTARG};;
        g) GIT_DIR=${OPTARG};;
        b) BRANCH=${OPTARG};;
    esac
done

echo "Deploying ${BRANCH} branch on server to target ${TARGET}..."
mkdir -p $TARGET
git --work-tree=$TARGET --git-dir=$GIT_DIR checkout -f $BRANCH
