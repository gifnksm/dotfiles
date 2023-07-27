# shellcheck source-path=SCRIPTDIR/..

assert_eq "${OS_NAME}" "${OS_UBUNTU_22_04}"

sudo DEBIAN_FRONTEND=noninteractive apt update
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y
