#!/usr/bin/env bash

#
# Copyright 2023 Task Re-engineering Inc.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# 

#for debugging
#set -ex

DESTINATION="$1"

copy_source_file() {
    local source_file_name="$1"
    
    cp -f "src/$source_file_name" "$MAIN_DIR/"
    chmod a+x "$MAIN_DIR/$source_file_name"
}

git fetch --tags

if [[ -z "$DESTINATION" ]];
then
    echo "Error: desination is required."
    exit 1
fi

git -C "$DESTINATION" rev-parse 2>/dev/null
if [[ $? = 0 ]];
then
    echo "An existing Git repository was found at the destination."
    is_bare=$(git -C $DESTINATION rev-parse --is-bare-repository)
    if [[ "$is_bare" = "false" ]];
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
GIT_DIR="$DESTINATION"

HOOKS_DIR="$GIT_DIR/hooks"
if [[ -f "$HOOKS_DIR/post-receive" ]];
then
    existing_hash=($(shasum "$HOOKS_DIR/post-receive"))
    new_hash=($(shasum "src/post-receive"))

    if [[ "$existing_hash" = "$new_hash" ]];
    then
        echo "An existing post-receive Git hook was found that matches the one in the installer."
        echo "Continuing with the installation..."
    else
        echo -e "An existing post-receive Git hook was found at \"$HOOKS_DIR/post-receive\" that does not match the one being installed."
        echo "Proceeding with the installation will replace the existing file."
        echo "If you proceed with the installation, any modifications you've made to the post-receive hook will be lost."
        echo -e "If you do not have a custom post-receive hook, then GitServerLite is simply updating the file.\n"
        echo "Are you sure you would like to continue? (y/n):"
    
        read confirmation
        if [[ "$confirmation" = "y" || "$confirmation" = "yes" ]];
        then
            echo "Continuing with the installation..."
        elif [[ "$confirmation" = "n" || "$confirmation" = "no" ]];
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
    . "$DESTINATION/.gitserverlite/env"
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

version=$(git describe --tags)
echo -e "GSL_VERSION=\"$version\"" > "$MAIN_DIR/version"

copy_source_file "gsl-source"
copy_source_file "matchanddeploy"

if [[ -z "$GSL_DEPLOY_DIR" ]];
then
    GSL_DEPLOY_DIR="$GIT_DIR/deploy"
    mkdir -p "$GSL_DEPLOY_DIR"
    echo -e "GSL_DEPLOY_DIR=\"deploy\"" >> "$MAIN_DIR/env"
    echo "Deploy location set to: \"deploy/\"."
else
    echo -e "Existing deploy location \""$GSL_DEPLOY_DIR"/\" used."
fi

if [[ -z "$GSL_DOCKER_COMPOSE_UP_PARAMS" ]];
then
    GSL_DOCKER_COMPOSE_UP_PARAMS="--build --detach"
    echo -e "GSL_DOCKER_COMPOSE_UP_PARAMS=\"$GSL_DOCKER_COMPOSE_UP_PARAMS\"" >> "$MAIN_DIR/env"
    echo "Docker compose up parameters set to: \""$GSL_DOCKER_COMPOSE_UP_PARAMS"\"."
else
    echo -e "Existing docker compose up parameters \""$GSL_DOCKER_COMPOSE_UP_PARAMS"\" used."
fi

GSL_DEPLOY_BRANCHES_DIR="$MAIN_DIR/deploy_branches"
mkdir -p "$GSL_DEPLOY_BRANCHES_DIR"
