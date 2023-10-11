# shellcheck source-path=SCRIPTDIR/../..

source lib/common.bash

TEST_DIR="${REPO_DIR}/test"
WORK_DIR="${TEST_DIR}/target"
ARCHIVE_PATH="${WORK_DIR}/archive.tar.gz"

_archive_repo() {
    info "Creating source archive"
    make -C "${TEST_DIR}" archive
}

_build_image() {
    local -r os_name="${1}"
    local -r image_type="${2}"

    info "Building docker image dotfiles-test-${os_name}-${image_type}"
    make -C "${TEST_DIR}" "build-image-${os_name}-${image_type}"
}

_run_container() {
    local -r image_name="${1}"
    local -r container_name="${2}"

    info "Running docker container ${container_name}"
    docker run \
        -d --rm --init \
        -v "${REPO_DIR}/bootstrap.bash:/bootstrap.bash:ro" \
        -v "${ARCHIVE_PATH}:/archive.tar.gz:ro" \
        --env GITHUB_ACTIONS \
        --env ARCHIVE_URL="file:///archive.tar.gz" \
        --env NO_PROTO_CHECK=true \
        --env NO_GIT_CLONE=true \
        --env GROUP_PREFIX="$(show_current_group)" \
        --name "${container_name}" \
        "${image_name}" \
        sleep infinity
}

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

_exec_in_container_root() {
    local -r container_name="${1}"
    shift

    info "Executing \`$*\` in docker container ${container_name}"
    docker exec \
        --env GITHUB_ACTIONS \
        --env GROUP_PREFIX="$(show_current_group)" \
        --user root:root \
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

    group_start "Create source archive"
    {
        _archive_repo
    }
    group_end

    group_start "Setup container"
    {
        _build_image "${os_name}" "${image_type}"
        _run_container "${image_name}" "${container_name}"
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

_test_install_common() {
    local -r dry_run="${1}"
    shift
    local -r os_name="${1}"
    shift

    local image_type
    if [[ "${dry_run}" = true ]]; then
        image_type=install-dry_run
    else
        image_type=install-normal
    fi
    local -r image_name="dotfiles-test-${os_name}-${image_type}"
    local -r container_name="${image_name}-$$"

    info "Running test for ${os_name}"

    group_start "Create source archive"
    {
        _archive_repo
    }
    group_end

    group_start "Setup container"
    {
        _build_image "${os_name}" "${image_type}"
        _run_container "${image_name}" "${container_name}"
    }
    group_end

    group_start "Extract archive"
    {
        _exec_in_container_root "${container_name}" mkdir -p /dotfiles
        local uid gid
        uid="$(_exec_in_container "${container_name}" id -u)"
        gid="$(_exec_in_container "${container_name}" id -g)"
        _exec_in_container_root "${container_name}" chown -R "${uid}:${gid}" /dotfiles
        _exec_in_container "${container_name}" tar -xzf /archive.tar.gz -C /
    }
    group_end

    group_start "Run the install script"
    {
        # Run the install script
        _exec_in_container "${container_name}" bash -c "/dotfiles/install $*"
        reset_last_group # The install script may output group_end
    }
    group_end

    if [[ "${dry_run}" = false ]]; then
        # Run the test script again to make sure it's idempotent
        group_start "Run the install script again"
        {
            # Run the bootstrap script
            _exec_in_container "${container_name}" bash -c "/dotfiles/install $*"
            reset_last_group # The install script may output group_end
        }
        group_end
    fi

    group_start "Cleanup container"
    {
        _stop_container "${container_name}"
    }
    group_end

    info "Test for ${os_name} succeeded"
}

test_install_normal() {
    local dry_run=false
    _test_install_common "${dry_run}" "$@"
}

test_install_dry_run() {
    local dry_run=true
    _test_install_common "${dry_run}" "$@" --dry-run
}
