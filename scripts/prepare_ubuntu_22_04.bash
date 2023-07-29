# shellcheck source-path=SCRIPTDIR/..

is_executed && return

assert_eq "${OS_ID}" "${OS_UBUNTU_22_04}"

sudo DEBIAN_FRONTEND=noninteractive apt -qq update
sudo DEBIAN_FRONTEND=noninteractive apt -qq upgrade -y
