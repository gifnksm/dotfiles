# shellcheck source-path=SCRIPTDIR/..

case "${OS_NAME}" in
"${OS_ARCH_LINUX}")
    source scripts/install_base_archlinux.bash
    ;;
*)
    error "${OS_NAME} is not supported."
    return "${ERROR_EXIT_CODE}"
    ;;
esac
