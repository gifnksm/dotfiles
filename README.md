# dotfiles

My dotfiles.

## Prerequisites

* a user account with sudo privilege
* `sudo` command
* distribution-specific package manager
  * Arch Linux: `pacman`
  * Ubuntu: `apt`
  * Rocky Linux: `dnf`

## Installation

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
