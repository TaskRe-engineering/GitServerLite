#!/bin/bash

#for debugging
#set -ex

DESTINATION=$1

echo "Initializing server at location $DESTINATION/"
git init --bare "$DESTINATION"
GIT_DIR=$DESTINATION

cp -f "src/gitserverlite" $GIT_DIR/
chmod a+x "$GIT_DIR/gitserverlite"

MAIN_DIR="$GIT_DIR/.gitserverlite"
mkdir -p "$MAIN_DIR"

VERSION=$(git describe --tags)
echo -e "VERSION=\"$VERSION\"" > "$MAIN_DIR/env"

cp -f "src/matchanddeploy" "$MAIN_DIR/"
chmod a+x "$MAIN_DIR/matchanddeploy"

DEPLOY_DIR="$GIT_DIR/deploy"
mkdir -p "$DEPLOY_DIR"
echo -e "DEPLOY_DIR=\"deploy\"" >> "$MAIN_DIR/env"

HOOKS_DIR="$GIT_DIR/hooks"
echo "Setting up git hooks in destination $HOOKS_DIR/"
cp -f "src/post-receive" "$HOOKS_DIR/"
chmod a+x "$HOOKS_DIR/post-receive"

DEPLOY_BRANCHES_DIR="$MAIN_DIR/deploy_branches"
mkdir -p "$DEPLOY_BRANCHES_DIR"
