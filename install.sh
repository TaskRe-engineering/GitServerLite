#!/bin/bash

#for debugging
#set -ex

DESTINATION=$1

DEPLOY_BRANCHES_NAME="deploy_branches"
DEPLOY_FILES_NAME="deploy_files"

echo "Initializing server at location $DESTINATION/"

git init --bare "$DESTINATION"
GIT_DIR=$DESTINATION

cp -f "src/gitserverlite" $GIT_DIR/
chmod a+x "$GIT_DIR/gitserverlite"

MAIN_DIR="$GIT_DIR/.gitserverlite"
mkdir -p $MAIN_DIR
echo "DEPLOY_BRANCHES_DIR=$DEPLOY_BRANCHES_NAME" > "$MAIN_DIR/locations"
echo "DEPLOY_FILES_DIR=$DEPLOY_FILES_NAME" >> "$MAIN_DIR/locations"
cp -f "src/matchanddeploy" $MAIN_DIR/
chmod a+x "$MAIN_DIR/matchanddeploy"

DEPLOY_FILES_DIR="$GIT_DIR/$DEPLOY_FILES_NAME"
echo "Creating deploy directory in destination $DEPLOY_FILES_DIR/"
mkdir -p "$DEPLOY_FILES_DIR/"

DEPLOY_BRANCHES_DIR="$GIT_DIR/$DEPLOY_BRANCHES_NAME"
echo "Creating container directory in destination $DEPLOY_BRANCHES_DIR/"
mkdir -p "$DEPLOY_BRANCHES_DIR/"

HOOKS_DIR="$GIT_DIR/hooks"
echo "Setting up git hooks in destination $HOOKS_DIR/"
cp -rf "hooks/post-receive" "$HOOKS_DIR/"
chmod a+x "$HOOKS_DIR/post-receive"
