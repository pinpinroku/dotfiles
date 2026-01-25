if status --is-interactive
    function fish_greeting
        fastfetch
    end

    ## Autostart zellij if the terminal is alacritty ##
    # if test $TERM = alacritty
    #     set ZELLIJ_AUTO_ATTACH true
    #     set ZELLIJ_AUTO_EXIT true
    #     eval (zellij setup --generate-auto-start fish | string collect)
    # end

    ## Set vi mode ##
    set -g fish_key_bindings fish_vi_key_bindings
    set -eU fish_key_bindings # cleanup old universal settings

    ## Cursor shape
    set fish_cursor_default block
    set fish_cursor_insert line

    ## Command color
    set -g fish_color_command brcyan

    ## Initialize atuin: CLI history manager
    atuin init fish | source
    set -g fish_history "" # disable default fish history

    ## Keybindings
    function fish_user_key_bindings
        # Change default incremental search function to atuin
        bind -M default / _atuin_search
    end

    ## Others
    starship init fish | source
    zoxide init fish | source # must be initialized at the end
end
