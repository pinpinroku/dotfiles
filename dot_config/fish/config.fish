if status --is-interactive
    function fish_greeting
        fastfetch
    end

    ## Prepend paths ##
    fish_add_path "$HOME/.local/bin" "$HOME/.cargo/bin"

    ## Set vi mode ##
    set -g fish_key_bindings fish_vi_key_bindings

    ## starship prompt ##
    # starship init fish | source

    ## zoxide: cd replacement ##
    zoxide init fish | source # must be initialized at the end
end
