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
    * Ubuntu, Debian: `apt`
    * Rocky Linux: `dnf`

## Installation

```console
curl -L --proto "=https" --tlsv1.2 -sSf https://raw.githubusercontent.com/gifnksm/dotfiles/main/bootstrap.bash | bash
```

By default, the bootstrap script downloads the latest version of the repository on `~/.local/share/dotfiles` and installs all packages.

After downloading the repository, you can install packages by running the `install` script manually.

```console
~/.local/share/dotfiles/install
```

If you want to install only specific packages, you can run the `install ${module_name}`.

```console
~/.local/share/dotfiles/install ${module_name}
```

All available modules can be listed by running the `install --list-modules`.

```console
~/.local/share/dotfiles/install --list-modules
```

## Supported OS

* Arch Linux
* Ubuntu 24.04 (Noble Numbat)
* Debian 12 (Bookworm)
* Rocky Linux 9

## Move dotfiles to another directory

```console
mv ${src_path} ${dst_path}
ln -s ${src_path} ${dst_path}
${dst_path}/install
```

After running the above commands, you can remove the `${src_path}` safely.

## Running tests

Docker is required to run tests.

```console
cd ${path_to_repository}
test/test_${test_name}
```
