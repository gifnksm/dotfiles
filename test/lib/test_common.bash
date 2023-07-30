# shellcheck source-path=SCRIPTDIR/../..

source lib/common.bash

is_executed && return

TEST_DIR="${REPO_DIR}/test"

_build_image() {
    local -r image_name="${1}"
    local -r dockerfile="${2}"

    info "Building docker image ${image_name}"
    docker buildx build --pull --load -t "${image_name}" -f "${dockerfile}" .
}

_run_container() {
    local -r image_name="${1}"
    local -r container_name="${2}"

    info "Running docker container ${container_name}"
    docker run -d --rm --init -v "${REPO_DIR}:/dotfiles" --name "${container_name}" "${image_name}" sleep infinity
}

_stop_container() {
    local -r container_name="${1}"

    info "Stopping docker container ${container_name}"
    docker stop "${container_name}"
}

_exec_in_container() {
    local -r container_name="${1}"
    local -r command="${2}"

    info "Executing '${command}' in docker container ${container_name}"
    docker exec "${container_name}" "${command}"
}

run_test() {
    local -r test_os_name="${1}"
    local -r test_script="${2}"

    local -r image_name="dotfiles-test-${test_os_name}"
    local -r dockerfile="${TEST_DIR}/docker/Dockerfile.${test_os_name}"
    local -r container_name="${image_name}-$$"

    info "Running test for ${test_os_name}"

    _build_image "${image_name}" "${dockerfile}"
    _run_container "${image_name}" "${container_name}"

    trap '_stop_container " ${container_name}"' EXIT

    # Run the test script
    _exec_in_container "${container_name}" "/dotfiles/${test_script}"
    info "First run for ${test_os_name} succeeded"

    # Run the test script again to make sure it's idempotent
    _exec_in_container "${container_name}" "/dotfiles/${test_script}"

    _stop_container "${container_name}"

    info "Test for ${test_os_name} succeeded"

    trap - EXIT
}