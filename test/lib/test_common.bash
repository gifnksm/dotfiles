# shellcheck source-path=SCRIPTDIR/../..

source lib/common.bash

is_executed && return

TEST_DIR="${REPO_DIR}/test"

run_test() {
    local -r test_os_name="${1}"

    local -r docker_image_name="dotfiles-test-${test_os_name}"
    local -r dockerfile="${TEST_DIR}/docker/Dockerfile.${test_os_name}"

    docker build --pull -t "${docker_image_name}" -f "${dockerfile}" .
    docker run --rm -v "${REPO_DIR}:/dotfiles" "${docker_image_name}" /dotfiles/install
}
