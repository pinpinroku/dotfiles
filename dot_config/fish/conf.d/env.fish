## Environment variables ##

# Text Editor
set -gx EDITOR /usr/bin/helix
set -gx VISUAL /usr/bin/helix

# fzf: A command-line fuzzy finder
set -gx FZF_DEFAULT_OPTS '--ansi --reverse'
set -gx FZF_DEFAULT_COMMAND 'fd \
    --type file \
    --strip-cwd-prefix \
    --hidden \
    --follow \
    --exclude .git \
    --color=always'
