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

# 
# GitServerLite - A lightweight set of scripts to set up and manage a Git repository
#                 that automatically deploys your Dockerized services for you.
#                 https://github.com/TaskRe-engineering/GitServerLite
# 
# File: install.sh
# Author: Kier von Konigslow
# Created: February 5, 2023
# 
# This script installs GitServerLite into a new or existing
# bare Git repository.
# 

#for debugging
#set -ex

DESTINATION="$1"

copy_source_file() {
    source_file_name="$1"
    
    cp -f "src/$source_file_name" "$MAIN_DIR/"
    chmod a+x "$MAIN_DIR/$source_file_name"
}

git fetch --tags

if [[ -z "$DESTINATION" ]];
then
    printf "Error: desination is required.\n"
    exit 1
fi

git -C "$DESTINATION" rev-parse 2>/dev/null
if [[ $? = 0 ]];
then
    printf "An existing Git repository was found at the destination.\n"
    is_bare=$(git -C $DESTINATION rev-parse --is-bare-repository)
    if [[ "$is_bare" = "false" ]];
    then
        printf "Error: This is not a bare repository. The installation can only proceed using a bare respoitory.\n"
        printf "Create a new repository or select a different location.\n"
        exit 1
    else
        printf "This is a bare repository and elibible for installation.\n"
        printf "Skipping re-initialization of the repository.\n"
    fi
else
    printf "No Git repository was found at the destination.\n"
    printf "Initializing a new installation at location %s/\n" "$DESTINATION"
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
        printf "An existing post-receive Git hook was found that matches the one in the installer.\n"
        printf "Continuing with the installation...\n"
    else
        printf "An existing post-receive Git hook was found at \"%s/post-receive\" that does not match the one being installed.\n" "$HOOKS_DIR"
        printf "Proceeding with the installation will replace the existing file.\n"
        printf "If you proceed with the installation, any modifications you've made to the post-receive hook will be lost.\n"
        printf "If you do not have a custom post-receive hook, then GitServerLite is simply updating the file.\n\n"
        printf "Are you sure you would like to continue? (y/n):\n"
    
        read confirmation
        if [[ "$confirmation" = "y" || "$confirmation" = "yes" ]];
        then
            printf "Continuing with the installation...\n"
        elif [[ "$confirmation" = "n" || "$confirmation" = "no" ]];
        then
            printf "Error: Installation cancelled by user. No files were changed.\n"
            exit 1
        else
            printf "Error: must be \"yes\", \"y\", \"no\", or \"n\"\n"
            exit 1
        fi
    fi
fi

if [[ -f "$DESTINATION/.gitserverlite/env" ]];
then
    . "$DESTINATION/.gitserverlite/env"
    printf "A previous installation of GitServerLite was found at this location.\n"
    printf "Scripts will be updated but user configurations will be preserved.\n"
fi

printf "Setting up git hooks in destination %s/.\n" "$HOOKS_DIR"
cp -f "src/post-receive" "$HOOKS_DIR/"
chmod a+x "$HOOKS_DIR/post-receive"

cp -f "src/gitserverlite" $GIT_DIR/
chmod a+x "$GIT_DIR/gitserverlite"

MAIN_DIR="$GIT_DIR/.gitserverlite"
mkdir -p "$MAIN_DIR"

version=$(git describe --tags)
printf "GSL_VERSION=\"%s\"\n" "$version" > "$MAIN_DIR/version"

copy_source_file "gsl-source"
copy_source_file "matchanddeploy"

if [[ -z "$GSL_DEPLOY_DIR" ]];
then
    GSL_DEPLOY_DIR="$GIT_DIR/deploy"
    mkdir -p "$GSL_DEPLOY_DIR"
    printf "GSL_DEPLOY_DIR=\"deploy\"\n" >> "$MAIN_DIR/env"
    printf "Deploy location set to: \"deploy/\".\n"
else
    printf "Existing deploy location \"%s/\" used.\n" "$GSL_DEPLOY_DIR"
fi

if [[ -z "$GSL_DOCKER_COMPOSE_UP_PARAMS" ]];
then
    GSL_DOCKER_COMPOSE_UP_PARAMS="--build --detach"
    printf "GSL_DOCKER_COMPOSE_UP_PARAMS=\"%s\"\n" "$GSL_DOCKER_COMPOSE_UP_PARAMS" >> "$MAIN_DIR/env"
    printf "Docker compose up parameters set to: \"%s\".\n" "$GSL_DOCKER_COMPOSE_UP_PARAMS"
else
    printf "Existing docker compose up parameters \"%s\" used.\n" "$GSL_DOCKER_COMPOSE_UP_PARAMS"
fi

GSL_DEPLOY_BRANCHES_DIR="$MAIN_DIR/deploy_branches"
mkdir -p "$GSL_DEPLOY_BRANCHES_DIR"
