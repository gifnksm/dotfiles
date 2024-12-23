def fzf-cmd [] -> str {
    if (which ^sk | length) > 0 {
        "sk"
    } else if (which ^fzf | length) > 0 {
        "fzf"
    } else {
        panic "no fzf found"
    }
}

def "souko list" [] {
    ^souko list --json |
        from json |
        get roots |
        rename --column {name: rootName} |
        select rootName repos |
        flatten --all
}

def "fzf select" [
    ...args: string
] {
    let fzf = fzf-cmd
    let list = $in
    let selected_items = $list | get display | str join "\n" | ^$fzf ...$args | into string | lines
    $list | filter {|row| $selected_items | any {|item| $item == $row.display } }
}

export def --env "jump repository" [] {
    let found_repos = souko list |
        upsert display {|row|
            let display_path = if ($row.relativePath | is-not-empty) { $row.relativePath } else { "." }
            $"[($row.rootName)] ($display_path)"
        } |
        fzf select "--exit-0" "--prompt=CHANGE DIRECTORY> " |
        get realPath
    if ($found_repos | is-not-empty) {
        export-env { cd ($found_repos | first) }
    }
}
