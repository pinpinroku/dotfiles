function y
    set tmp (mktemp -p '/tmp' 'yazi-cwd.XXXXXX')
    yazi $argv --cwd-file="$tmp"
    if read -z cwd <"$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    command rm -f -- "$tmp"
end
