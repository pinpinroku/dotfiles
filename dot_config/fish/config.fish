if status --is-interactive
    function fish_greeting
        fastfetch
    end

    ## Prepend paths ##
    fish_add_path "$HOME/.local/bin" "$HOME/.cargo/bin"

    ## Autostart zellij if the terminal is alacritty ##
    # if test $TERM = alacritty
    #     set ZELLIJ_AUTO_ATTACH true
    #     set ZELLIJ_AUTO_EXIT true
    #     eval (zellij setup --generate-auto-start fish | string collect)
    # end

    ## Set vi mode ##
    set -g fish_key_bindings fish_vi_key_bindings

    ## Others ##
    starship init fish | source
    zoxide init fish | source # must be initialized at the end
end
