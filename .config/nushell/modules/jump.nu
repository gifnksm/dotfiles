def "souko list" [] {
    ^souko list --json |
        from json |
        get roots |
        rename --column {name: rootName} |
        select rootName repos |
        flatten --all
}

export def --env "jump repository" [] {
    let found_repo = souko list |
        upsert display {|row|
            let display_path = if ($row.relativePath | is-not-empty) { $row.relativePath } else { "." }
            $"[($row.rootName)] ($display_path)"
        } |
        (sk
            --prompt='CHANGE DIRECTORY> '
            --format {get display}
        )
    if ($found_repo | is-not-empty) {
        export-env { cd ($found_repo | get realPath) }
    }
}
