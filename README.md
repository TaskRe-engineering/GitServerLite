# SimpleGitWebServer

SimpleGitWebServer is a lightweight Git server framework to automate deployment of a web server using a Dockerfile. Branches in your repository can be matched to docker configurations, which are automatically built and run when you push to the branch.

## Prerequisites

The following prerequisites need to be installed before proceeding. You can find installation instructions from thei individual websites.

- SSH server
- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [Docker](https://docs.docker.com/engine/install/debian/)

Finally, the web server's repository needs to have a Dockerfile, which is assumed to set up the web server.

## Installation

These installations instructions will give you a lightweight git server.

### Creating a git user and setting permissions

There needs to be a user called Git on the system. You'll be using SSH to log in as this user in order use the repository. The Git user will need read-write access to the folder containing the repository.

First, add the user. Keep a record of their password, but this will not be used to interact with the repository since password authentication will be disabled.

```bash
adduser git
```

Next, switch to this user.
``` bash
su git
```

Create the (hidden) SSH folder and ensure that only the git user has access to it.
```bash
mkdir ~/.ssh
chmod 700 .ssh
```

Create the file setting which public keys can be used to authenticate as this user and make sure only this user has access.
```bash
touch .ssh/authorized_keys
chmod 600 .ssh/authorized_keys
```
Finally, edit the file `.ssh/authorized_keys` file to add the public keys of each user that will get access to the repository. Each key should be on its own line.

### Finalizing the installation

Log into the server as the Git user and run the installation script.

```bash
./install.sh <path to git remote>
```

It is very important that the newly created files and folders are owned by the Git user. Make sure to either run the installation script as the Git user, or change ownership of the `containers/`, `deploy/`, and `hooks/` folders to belog to that user, recursively.

## Configuration

For each branch you would like to automatically deploy, create a configuration file in the repository's `containers/` folder. Each file must have the extension `.conf`.

Configuration files should be formatted as Shell scripts, and need to have the following variables:

| Variable name | Type | Default |
| -- | -- | -- |
| BRANCH | String (required) |  |
| PORT | Integer | 80 |
| IMAGE_NAME | String | web-$BRANCH |
| CONTAINER_NAME | String | $IMAGE_NAME |
| RESTART | String | always (no, on-failure:<# retries>, always, unless-stopped) |

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

For development testing, the file `experimental.conf` could contain:
```bash
BRANCH="develop"
PORT=8080
IMAGE_NAME="my_website-exp-image"
CONTAINER_NAME="my_website-exp"
RESTART="unless-stopped"
```
This would automatically deploy the `develop` branch on port 8080 whenever you push to the remote's `develop` branch.

IMPORTANT: To reduce clutter, each time you push to one of these branches, the existing container and image are permanently deleted. Volumes for persistence are not currently supported, but may be added in a future release.