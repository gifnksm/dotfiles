# shellcheck source-path=SCRIPTDIR/..

assert_eq "${OS_NAME}" "${OS_ROCKY_LINUX_9}"

sudo dnf update -y
sudo dnf install -y epel-release util-linux-user
