# shellcheck source-path=SCRIPTDIR/..

case "${OS_NAME}" in
"${OS_ARCH_LINUX}")
    source scripts/prepare_archlinux.bash
    ;;
"${OS_UBUNTU_22_04}")
    source scripts/prepare_ubuntu_22_04.bash
    ;;
"${OS_ROCKY_LINUX_9}")
    source scripts/prepare_rockylinux_9.bash
    ;;
*)
    error "${OS_NAME} is not supported."
    return "${ERROR_EXIT_CODE}"
    ;;
esac
