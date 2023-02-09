# GitServerLite

## Summary

GitServerLite is a lightweight script to set up a Git repository that automatically deploys your Dockerized services for you. You can easily set it up to automatically deploy your services when you push to a specific branch, and even supports mapping branches to different environments. All you need is the GitServerLite install script, Git, and Docker.

## Requirements

### Your Repository

The only requirement of your repository is that it can be deployed using [Docker Compose](https://docs.docker.com/compose/).

Deploying multiple environments is done using [.env files](https://docs.docker.com/compose/).

### Dependencies

The following dependencies need to be installed before proceeding. You can find installation instructions from their individual websites.

- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [Docker](https://docs.docker.com/engine/install/debian/)

## Installation

On your server, log in as the user that will be making the pushes. If you are using SSH, this will likely be the user called **git**.

```bash
./gitserverlite-install <path to git remote>
```

## Configuration

For each branch you would like to automatically deploy, create a file in the `deploy_branches` folder with a name that matches the branch name.

Configuration files should be formatted as Shell scripts, and need to have the following variables:

| Variable name | Default |
| -- | -- |
| ENV_FILE | (Optional) |
| PRUNE_ON_DEPLOY | true |

For example, if you have a `main` branch and a `develop` branch that you'd like to match to a `production` and `experimental` container, respectively, then you can create the following files:

The file `production.conf` could contain:

```bash
BRANCH="main"
PORT=80
IMAGE_NAME="my_website-prod-image"
CONTAINER_NAME="my_website-prod"
RESTART="always"
```
This would automatically deploy the `main` branch on port 80 whenever you push to the remote's `main` branch.