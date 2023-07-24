# shellcheck source-path=SCRIPTDIR/..

assert_eq "${OS_NAME}" "${OS_UBUNTU_22_04}"

sudo apt update
sudo apt upgrade -y
