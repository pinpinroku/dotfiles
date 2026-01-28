# Text editor
set -gx EDITOR /usr/bin/helix
set -gx VISUAL /usr/bin/helix

# Cutstom starship prompt
set -gx STARSHIP_CONFIG "$HOME/.config/starship/starship-mokka.toml"

# bat: cat replacement
set -gx BAT_STYLE 'snip,changes,header'

# fzf: A command-line fuzzy finder
set -gx FZF_DEFAULT_OPTS '--ansi --reverse'
set -gx FZF_DEFAULT_COMMAND 'fd --hidden --exclude .git --color=always'

# mpd: Music Player Daemon
set -gx MPD_HOST "$XDG_RUNTIME_DIR/mpd/socket"

# Format man pages
set -gx MANROFFOPT -c
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
