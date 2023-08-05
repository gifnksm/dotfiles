# dotfiles

My dotfiles.

## Prerequisites

* For bootstrap script
  * `curl` command
  * `tar` command
* For install script
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

* Install all packages

    ```console
    cd ${path_to_repository}
    ./install
    ```

* Install only specific packages

    ```console
    cd ${path_to_repository}
    ./scripts/install_${package_name}
    ```

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
