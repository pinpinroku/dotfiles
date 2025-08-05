function y
    # Wrapper function to move current directory interactively in yazi

    set tmp (mktemp -p /tmp yazi-cwd.XXXXXX)
    yazi $argv --cwd-file=$tmp
    if set cwd (command cat -- $tmp); and [ -n $cwd ]; and [ $cwd != $PWD ]
        builtin cd -- $cwd
    end
    command rm -f -- $tmp
end
