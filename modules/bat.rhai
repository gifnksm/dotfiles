import "os" as os;

switch os::ID {
    "arch" => {
        log::info("Arch Linux");
    },
    "ubuntu-22.04" => {
        log::info("Ubuntu 22.04");
    },
    "debian-12" => {
        log::info("Debian 12")
    },
    "rocky-9" => {
        log::info("Rocky Linux");
    },
    _ => {
        throw "Unsupported OS";
    }
}

env::execute_command("echo hello");
let out = env::query_command("echo stderr >&2");
log::info(`stdout=${out}`);
let out = env::query_command("echo stdout");
log::info(`stdout=${out}`);
try {
    env::query_command("dpkg -s bat");
}
catch {
    print("bat is not installed");
}

env::query_command("dpkg -s batx 2>&1 > /dev/null");
