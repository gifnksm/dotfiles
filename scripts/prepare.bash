# shellcheck source-path=SCRIPTDIR/..

case "${OS_ID}" in
"${OS_ARCH}")
    source scripts/prepare_arch.bash
    ;;
"${OS_UBUNTU_22_04}")
    source scripts/prepare_ubuntu_22_04.bash
    ;;
"${OS_ROCKY_9}")
    source scripts/prepare_rocky_9.bash
    ;;
*)
    error "${OS_ID} is not supported."
    return "${ERROR_EXIT_CODE}"
    ;;
esac
