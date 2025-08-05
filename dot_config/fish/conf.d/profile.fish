if status --is-interactive
    # Starshipt prompt
    set -gx STARSHIP_CONFIG ~/.config/starship/starship-mokka.toml

    # Text editor
    set -gx EDITOR /usr/bin/helix
    set -gx VISUAL /usr/bin/helix

    # bat: cat replacement
    set -gx BAT_STYLE 'snip,changes,header'

    # fzf: A command-line fuzzy finder
    set -gx FZF_DEFAULT_OPTS '--ansi --reverse'
    set -gx FZF_DEFAULT_COMMAND 'fd \
        --type file \
        --strip-cwd-prefix \
        --hidden \
        --follow \
        --exclude .git \
        --color=always'

    ## Autostart zellij if the terminal is alacritty ##
    if test $TERM = alacritty
        set ZELLIJ_AUTO_ATTACH true
        set ZELLIJ_AUTO_EXIT true
        eval (zellij setup --generate-auto-start fish | string collect)
    end

    ## Set vi mode ##
    fish_vi_key_bindings
    set fish_cursor_default block
    set fish_cursor_insert line

    ## Initialize starship ##
    starship init fish | source

    ## Initialize zoxide ##
    zoxide init fish | source
end
