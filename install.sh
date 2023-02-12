#!/bin/bash

#for debugging
#set -ex

DESTINATION=$1

if [[ -z $DESTINATION ]];
then
    echo "Error: desination is required."
    exit 1
fi

git -C $DESTINATION rev-parse 2>/dev/null
if [[ $? = 0 ]];
then
    echo "An existing Git repository was found at the destination."
    echo "Skipping re-initialization of the repository."
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
        echo "Existing post-receive Gi hook matches new one. Continuing with installation."
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
            echo "Installation cancelled by user. No files were changed."
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

cp -f "src/matchanddeploy" "$MAIN_DIR/"
chmod a+x "$MAIN_DIR/matchanddeploy"

if [[ -z $DEPLOY_DIR ]];
then
    DEPLOY_DIR="$GIT_DIR/deploy"
    echo -e "DEPLOY_DIR=\"deploy\"" >> "$MAIN_DIR/env"
    echo "Deploy location set to: \"deploy/\"."
else
    echo -e "Existing deploy location \"$DEPLOY_DIR/\" used."
fi
mkdir -p "$DEPLOY_DIR"

DEPLOY_BRANCHES_DIR="$MAIN_DIR/deploy_branches"
mkdir -p "$DEPLOY_BRANCHES_DIR"
