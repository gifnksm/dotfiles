# shellcheck source-path=SCRIPTDIR/../..

source lib/common.bash

is_executed && return

TEST_DIR="${REPO_DIR}/test"

_archive_repo() {
    local archive_path="${1}"
    local commit_hash
    commit_hash="$(git stash create)"
    git archive --prefix=dotfiles/ "${commit_hash:-HEAD}" -o "${archive_path}"
}

_build_image() {
    local -r image_name="${1}"
    local -r dockerfile="${2}"
    local -r bootstrap="${3:-false}"

    info "Building docker image ${image_name}"
    docker buildx build --pull --load \
        --build-arg bootstrap="${bootstrap}" \
        -t "${image_name}" \
        -f "${dockerfile}" \
        .
}

_run_container() {
    local -r image_name="${1}"
    local -r container_name="${2}"
    local -r archive_path="${3}"

    info "Running docker container ${container_name}"
    docker run \
        -d --rm --init \
        -v "${REPO_DIR}/bootstrap.bash:/bootstrap.bash:ro" \
        -v "${archive_path}:/archive.tar.gz:ro" \
        --env GITHUB_ACTIONS \
        --env ARCHIVE_URL="file:///archive.tar.gz" \
        --env NO_PROTO_CHECK=true \
        --env NO_GIT_CLONE=true \
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
        "${container_name}" \
        "$@"
}

test_bootstrap() {
    local -r test_os_name="${1}"
    shift

    local -r image_name="dotfiles-test-${test_os_name}-bootstrap"
    local -r dockerfile="${TEST_DIR}/docker/Dockerfile.${test_os_name}"
    local -r container_name="${image_name}-$$"

    info "Running test for ${test_os_name}"

    local work_dir archive_path
    work_dir="$(mktemp -d)"
    archive_path="${work_dir}/archive.tar.gz"

    group_start "Create source archive"
    {
        _archive_repo "${archive_path}"
    }
    group_end

    group_start "Setup container"
    {
        _build_image "${image_name}" "${dockerfile}" true
        _run_container "${image_name}" "${container_name}" "${archive_path}"
    }
    group_end

    group_start "Run the bootstrap script"
    {
        # Run the bootstrap script
        _exec_in_container "${container_name}" bash -c "cat /bootstrap.bash | bash -s -- $*"
    }
    group_end

    group_start "Cleanup container"
    {
        _stop_container "${container_name}"
    }

    group_start "Cleanup working directory"
    {
        rm -rf "${work_dir}"
    }

    info "Test for ${test_os_name} succeeded"
}

test_install() {
    local -r test_os_name="${1}"
    shift

    local -r image_name="dotfiles-test-${test_os_name}-install"
    local -r dockerfile="${TEST_DIR}/docker/Dockerfile.${test_os_name}"
    local -r container_name="${image_name}-$$"

    info "Running test for ${test_os_name}"

    local work_dir archive_path
    work_dir="$(mktemp -d)"
    archive_path="${work_dir}/archive.tar.gz"

    group_start "Create source archive"
    {
        _archive_repo "${archive_path}"
    }
    group_end

    group_start "Setup container"
    {
        _build_image "${image_name}" "${dockerfile}"
        _run_container "${image_name}" "${container_name}" "${archive_path}"
    }
    group_end

    group_start "Extract archive"
    {
        _exec_in_container "${container_name}" sudo mkdir -p /dotfiles
        local uid gid
        uid="$(_exec_in_container "${container_name}" id -u)"
        gid="$(_exec_in_container "${container_name}" id -g)"
        _exec_in_container "${container_name}" sudo chown -R "${uid}:${gid}" /dotfiles
        _exec_in_container "${container_name}" tar -xzf /archive.tar.gz -C /
    }
    group_end

    group_start "Run the install script"
    {
        # Run the bootstrap script
        _exec_in_container "${container_name}" bash -c "/dotfiles/install $*"
    }

    # Run the test script again to make sure it's idempotent
    group_start "Run the install script again"
    {
        # Run the bootstrap script
        _exec_in_container "${container_name}" bash -c "/dotfiles/install $*"
    }

    group_start "Cleanup container"
    {
        _stop_container "${container_name}"
    }

    group_start "Cleanup working directory"
    {
        rm -rf "${work_dir}"
    }

    info "Test for ${test_os_name} succeeded"
}
