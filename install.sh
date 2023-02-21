#!/bin/bash

#for debugging
#set -ex

#
# Copyright © 2023 Task Re-engineering Inc.
# All rights reserved.
# 
# This source code is licensed under the [] license found in the
# LICENSE file in the root directory of this source tree. 
# 

DESTINATION=$1

git fetch --tags

if [[ -z $DESTINATION ]];
then
    echo "Error: desination is required."
    exit 1
fi

git -C $DESTINATION rev-parse 2>/dev/null
if [[ $? = 0 ]];
then
    echo "An existing Git repository was found at the destination."
    IS_BARE=$(git -C $DESTINATION rev-parse --is-bare-repository)
    if [[ "$IS_BARE" = "false" ]];
    then
        echo "Error: This is not a bare repository. The installation can only proceed using a bare respoitory."
        echo "Create a new repository or select a different location."
        exit 1
    else
        echo "This is a bare repository and elibible for installation."
        echo "Skipping re-initialization of the repository."
    fi
else
    echo "No Git repository was found at the destination."
    echo "Initializing a new installation at location $DESTINATION/"
    git init --bare "$DESTINATION"
fi
GIT_DIR=$DESTINATION

HOOKS_DIR="$GIT_DIR/hooks"
if [[ -f "$HOOKS_DIR/post-receive" ]];
then
    EXISTING_HASH=($(shasum "$HOOKS_DIR/post-receive"))
    NEW_HASH=($(shasum "src/post-receive"))

    if [[ "$EXISTING_HASH" = "$NEW_HASH" ]];
    then
        echo "An existing post-receive Git hook was found that matches the one in the installer."
        echo "Continuing with the installation..."
    else
        echo -e "An existing post-receive Git hook was found at \"$HOOKS_DIR/post-receive\" that does not match the one being installed."
        echo "Proceeding with the installation will replace the existing file."
        echo "If you proceed with the installation, any modifications you've made to the post-receive hook will be lost."
        echo -e "If you do not have a custom post-receive hook, then GitServerLite is simply updating the file.\n"
        echo "Are you sure you would like to continue? (y/n):"
    
        read CONFIRMATION
        if [[ "$CONFIRMATION" = "y" || "$CONFIRMATION" = "yes" ]];
        then
            echo "Continuing with the installation..."
        elif [[ "$CONFIRMATION" = "n" || "$CONFIRMATION" = "no" ]];
        then
            echo "Error: Installation cancelled by user. No files were changed."
            exit 1
        else
            echo -e "Error: must be \"yes\", \"y\", \"no\", or \"n\""
            exit 1
        fi
    fi
fi

if [[ -f "$DESTINATION/.gitserverlite/env" ]];
then
    source "$DESTINATION/.gitserverlite/env"
    echo "A previous installation of GitServerLite was found at this location."
    echo "Scripts will be updated but user configurations will be preserved."
fi

echo "Setting up git hooks in destination $HOOKS_DIR/"
cp -f "src/post-receive" "$HOOKS_DIR/"
chmod a+x "$HOOKS_DIR/post-receive"

cp -f "src/gitserverlite" $GIT_DIR/
chmod a+x "$GIT_DIR/gitserverlite"

MAIN_DIR="$GIT_DIR/.gitserverlite"
mkdir -p "$MAIN_DIR"

VERSION=$(git describe --tags)
echo -e "VERSION=\"$VERSION\"" > "$MAIN_DIR/version"

cp -f "src/gsl-source" "$MAIN_DIR/"
chmod a+x "$MAIN_DIR/gsl-source"

cp -f "src/matchanddeploy" "$MAIN_DIR/"
chmod a+x "$MAIN_DIR/matchanddeploy"

if [[ -z $DEPLOY_DIR ]];
then
    DEPLOY_DIR="$GIT_DIR/deploy"
    mkdir -p "$DEPLOY_DIR"
    echo -e "DEPLOY_DIR=\"deploy\"" >> "$MAIN_DIR/env"
    echo "Deploy location set to: \"deploy/\"."
else
    echo -e "Existing deploy location \"$DEPLOY_DIR/\" used."
fi

DEPLOY_BRANCHES_DIR="$MAIN_DIR/deploy_branches"
mkdir -p "$DEPLOY_BRANCHES_DIR"
