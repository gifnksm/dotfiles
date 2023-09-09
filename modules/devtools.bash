# shellcheck source-path=SCRIPTDIR/..
group_start_file
{
    install_package_by_spec <<END
        arch: base-devel
        ubuntu-22.04: build-essential
        rocky-9: $(pkg_encode <<<"@Development Tools")
END
}
group_end
