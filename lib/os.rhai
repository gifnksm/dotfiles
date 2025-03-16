export const RELEASE_INFO = open_os_release();

export const ID_ARCH = "arch";
export const ID_UBUNTU_2204 = "ubuntu-22.04";
export const ID_DEBIAN_12 = "debian-12";
export const ID_ROCKY_9 = "rocky-9";

let raw_id = `${RELEASE_INFO.id}-${RELEASE_INFO.version_id}`;
export const ID = if raw_id.starts_with("arch-") {
    ID_ARCH
} else if raw_id == "ubuntu-22.04" {
    ID_UBUNTU_2204
} else if raw_id == "debian-12" {
    ID_DEBIAN_12
} else if raw_id.starts_with("rocky-9") {
    ID_ROCKY_9
} else {
    throw `Unsupported OS: ${raw_id}`;
};
