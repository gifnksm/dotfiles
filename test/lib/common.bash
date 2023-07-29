# shellcheck source-path=SCRIPTDIR/..

_init_check_test_dir() {
    if ! [[ -v TEST_DIR ]]; then
        error "TEST_DIR is not set."
        return 1
    fi
    if ! [[ -d "${TEST_DIR}" ]]; then
        error "TEST_DIR is not a directory: ${TEST_DIR}"
        return 1
    fi
}

REPO_DIR="$(realpath "${TEST_DIR}/..")"

run_test() {
    local -r test_os_name="${1}"

    local -r docker_image_name="dotfiles-test-${test_os_name}"
    local -r dockerfile="${TEST_DIR}/Dockerfile.${test_os_name}"

    docker build --pull -t "${docker_image_name}" -f "${dockerfile}" .
    docker run --rm -v "${REPO_DIR}:/dotfiles" "${docker_image_name}" /dotfiles/install
}

_init_check_test_dir
