# shellcheck source-path=SCRIPTDIR/../..

source lib/common.bash

TEST_DIR="${REPO_DIR}/test"

_stop_container() {
    local -r container_name="${1}"

    info "Stopping docker container ${container_name}"
    docker stop "${container_name}"
}

_exec_in_container() {
    local -r container_name="${1}"
    shift

    info "Executing \`$*\` in docker container ${container_name}"
    docker exec \
        --env GITHUB_ACTIONS \
        --env GROUP_PREFIX="$(show_current_group)" \
        "${container_name}" \
        "$@"
}

test_bootstrap() {
    local -r os_name="${1}"
    shift

    local -r image_type=bootstrap
    local -r image_name="dotfiles-test-${os_name}-${image_type}"
    local -r container_name="${image_name}-$$"

    info "Running test for ${os_name}"

    group_start "Setup container"
    {
        make -C "${TEST_DIR}" "run-${os_name}-${image_type}" CONTAINER_NAME="${container_name}"
    }
    group_end

    group_start "Run the bootstrap script"
    {
        # Run the bootstrap script
        _exec_in_container "${container_name}" bash -c "cat /bootstrap.bash | bash -s -- $*"
        reset_last_group # The bootstrap script may output group_end
    }
    group_end

    group_start "Cleanup container"
    {
        _stop_container "${container_name}"
    }
    group_end

    info "Test for ${os_name} succeeded"
}

test_install_normal() {
    local -r os_name="${1}"
    shift

    local -r image_type=install-normal
    local -r image_name="dotfiles-test-${os_name}-${image_type}"
    local -r container_name="${image_name}-$$"

    info "Running test for ${os_name}"

    group_start "Setup container"
    {
        make -C "${TEST_DIR}" "run-${os_name}-${image_type}" CONTAINER_NAME="${container_name}"
    }
    group_end

    group_start "Run the install script"
    {
        # Run the install script
        _exec_in_container "${container_name}" bash -c "/dotfiles/install $*"
        reset_last_group # The install script may output group_end
    }
    group_end

    # Run the test script again to make sure it's idempotent
    group_start "Run the install script again"
    {
        # Run the bootstrap script
        _exec_in_container "${container_name}" bash -c "/dotfiles/install $*"
        reset_last_group # The install script may output group_end
    }
    group_end

    group_start "Cleanup container"
    {
        _stop_container "${container_name}"
    }
    group_end

    info "Test for ${os_name} succeeded"
}

test_install_dry_run() {
    local -r os_name="${1}"
    shift

    local -r image_type=install-dry_run
    local -r image_name="dotfiles-test-${os_name}-${image_type}"
    local -r container_name="${image_name}-$$"

    info "Running test for ${os_name}"

    group_start "Setup container"
    {
        make -C "${TEST_DIR}" "run-${os_name}-${image_type}" CONTAINER_NAME="${container_name}"
    }
    group_end

    group_start "Run the install script"
    {
        # Run the install script
        _exec_in_container "${container_name}" bash -c "/dotfiles/install --dry-run $*"
        reset_last_group # The install script may output group_end
    }
    group_end

    group_start "Cleanup container"
    {
        _stop_container "${container_name}"
    }
    group_end

    info "Test for ${os_name} succeeded"
}
