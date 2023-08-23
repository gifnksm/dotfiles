# dotfiles

My dotfiles.

## Prerequisites

* For bootstrap script
  * `bash` command
  * `curl` command
  * `tar` command
* For install script
  * `bash` command
  * `sudo` command
  * a user account with sudo privilege
  * distribution-specific package manager command
    * Arch Linux: `pacman`
    * Ubuntu: `apt`
    * Rocky Linux: `dnf`

## Installation

```console
curl -L --proto "=https" --tlsv1.2 -sSf https://raw.githubusercontent.com/gifnksm/dotfiles/master/bootstrap.bash | bash
```

By default, the bootstrap script downloads the latest version of the repository on `~/.local/share/dotfiles` and installs all packages.

After downloading the repository, you can install packages by running the `install` script manually.

```console
~/.local/share/dotfiles/install
```

<!-- If you want to install only specific packages, you can run the `install_${package_name}` script.

```console
~/.local/share/dotfiles/scripts/install_${package_name}
``` -->

## Supported OS

* Arch Linux
* Ubuntu 22.04 (Jammy Jellyfish)
* Rocky Linux 9

## Running tests

Docker is required to run tests.

```console
cd ${path_to_repository}
test/test_${test_name}
```
