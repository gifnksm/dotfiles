# shellcheck source-path=SCRIPTDIR/..

install_package_by_spec <<END
    arch: base-devel
    ubuntu-24.04: build-essential
    debian-12: build-essential
    rocky-9: $(pkg_encode <<<"@Development Tools")
END
