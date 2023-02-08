#!/bin/bash

#for debugging
#set -ex

DESTINATION=$1

git init --bare $DESTINATION
GIT_DIR=$DESTINATION

DEPLOY_DIR="$GIT_DIR/deploy_files"
echo "Creating deploy directory in destination $DEPLOY_DIR/."
mkdir -p "$DEPLOY_DIR/"

CONTAINER_DIR="$GIT_DIR/containers"
echo "Creating container directory in destination $CONTAINER_DIR/."
cp -r "containers/" "$CONTAINER_DIR/"
chmod a+x "$CONTAINER_DIR/."

HOOKS_DIR="$GIT_DIR/hooks"
echo "Setting up git hooks in destination $HOOKS_DIR/."
cp -rf "hooks/post_receive" "$HOOKS_DIR/"
chmod a+x "$HOOKS_DIR/post_receive"
