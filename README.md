# GitServerLite

## Summary

GitServerLite is a lightweight script to set up a Git repository that automatically deploys your Dockerized services for you. You can easily set it up to automatically deploy your services when you push to a specific branch, and even supports mapping branches to different environments. All you need is the GitServerLite install script, Git, and Docker.

## Requirements

### Your Repository

The only requirement of your repository is that it can be deployed using [Docker Compose](https://docs.docker.com/compose/).

Deploying multiple environments is done using [.env files](https://docs.docker.com/compose/).

### System Dependencies

The following dependencies need to be installed before proceeding. You can find installation instructions from their individual websites.

- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [Docker](https://docs.docker.com/engine/install/debian/)

The installation script also uses `shasum` to check if there's an existing post-receive hook so that user files are not overwitten. This should already be installed on many systems, but you can check if it is available by running the command `which shasum` and making sure you can see the existing installation's path.

## Installation

On your server, log in as the user that will be making the pushes. If you are using SSH, this will likely be the user called **git**.

Clone GitServerLite and navigate to the root of the repository. To install a new server, run the command:

```bash
./install <destination>
```
where `<destination>` is the location where you would like the remote repository to live. This will be the path that you use to track your remote repository.

If there is no existing repository at that location, GitServerLite will create a new bare repository and install its scripts.

If there is an existing (bare) repository at that location, then GitServerLite will install its scripts while checking to make sure that it is not overwriting existing Git hooks. If you already have a custom `post-receive` hook, it will ask you before replacing it.

If the destination already contains a GitServerLite repository, it will update the existing scripts while leaving user configuration intact.

For example, if you would like your server to be a Git repository at location `/var/git/my_server.git` then you would run
```bash
./install /var/git/my_server.git
```

## Management

To manage GitServerLite's configuration, navigate to the root of the repository (the destination you specified in the installation) and use the `gitserverlite` script to run commands. You can find a list of commands below, or run `./gitserverlite help` to see usage help.

### Add a deploy branch

A deploy branch is a Git branch that is configured to automatically deploy your Docker Compose file when you push to the GitServerLite repository. GitServerLite stores a deploy branch record for each of these branches.

To add a deploy branch record, run
```bash
./gitserverlite add-branch <branch name>
```

You will be prompted to enter the (optional) name of an `.env` file as well as whether or not you'd like to run `docker system prune` after each deployment. `.env` files allow you to use variables in your Docker Compose configuration that represent different environments. For example, `.env` could represent production and specify the port `443` for a published HTTPS service, while `.env.dev` could represent a testing environment that using the port `8443` for that same service to allow for separate testing.

If you don't provide a `.env` file, you can simply press enter to proceed. If no `.env` file is specified, Docker Compose will automatically look for one called `.env` if it exists, an continue without one otherwise. See [Docker Compose Environment Variable Overview](https://docs.docker.com/compose/environment-variables/) for details.

You can also use this to overwrite an existing record. If the branch already has a deplouy branch record in GitServerLite, it will simply be replaced.

### Remove a deploy branch

To remove an existing deploy branch record, run
```bash
./gitserverlite remove-branch <branch name>
```

This will not remove the branch itself, but only the deploy branch record from GitServerLite. Once a deploy branch record has been removed, GitServerLite will not longer automatically deploy when changes are pushed to that branch.

### List all deploy branch records

To list all deploy branch records, run
```bash
./gitserverlite list
```

This will list all branches configured to automatically deploy.

### Show a deploy branch record

To show the details of a deploy branch record, run
```bash
./gitserverlite show-branch <branch name>
```

This will show the details of that deploy branch record.

### Show the deploy location

To show the folder that GitServerLite is using to deploy the repository's files before building and running its Docker containers, run
```bash
./gitserverlite show-deploy-location
```

### Version

To show the version of the currently installed GitServerLite, run
```bash
./gitserverlite version
```

### Help

To show the list of GitServerLite commands, run
```bash
./gitserverlite help
```

## License

This source code is licensed under the <> license found in the [LICENSE](LICENSE.txt) file in the root directory of this source tree.