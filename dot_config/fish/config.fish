## Set values
# Hide welcome message & ensure we are reporting fish as shell
set fish_greeting
set VIRTUAL_ENV_DISABLE_PROMPT 1
set -xU MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -xU MANROFFOPT -c
set -x SHELL /usr/bin/fish

## Export variable need for qt-theme
if type qtile >>/dev/null 2>&1
    set -x QT_QPA_PLATFORMTHEME qt5ct
end

# Set settings for https://github.com/franciscolourenco/done
set -U __done_min_cmd_duration 10000
set -U __done_notification_urgency_level low

## Environment setup
# Apply .profile: use this to put fish compatible .profile stuff in
if test -f ~/.fish_profile
    source ~/.fish_profile
end

# Add ~/.local/bin to PATH
if test -d ~/.local/bin
    if not contains -- ~/.local/bin $PATH
        set -p PATH ~/.local/bin
    end
end

# Add depot_tools to PATH
if test -d ~/Applications/depot_tools
    if not contains -- ~/Applications/depot_tools $PATH
        set -p PATH ~/Applications/depot_tools
    end
end


## Starship prompt
if status --is-interactive
    source ("/usr/bin/starship" init fish --print-full-init | psub)
end

## Functions
# Functions needed for !! and !$ https://github.com/oh-my-fish/plugin-bang-bang
function __history_previous_command
    switch (commandline -t)
        case "!"
            commandline -t $history[1]
            commandline -f repaint
        case "*"
            commandline -i !
    end
end

function __history_previous_command_arguments
    switch (commandline -t)
        case "!"
            commandline -t ""
            commandline -f history-token-search-backward
        case "*"
            commandline -i '$'
    end
end

if [ "$fish_key_bindings" = fish_vi_key_bindings ]
    bind -Minsert ! __history_previous_command
    bind -Minsert '$' __history_previous_command_arguments
else
    bind ! __history_previous_command
    bind '$' __history_previous_command_arguments
end

# Fish command history
function history
    builtin history --show-time='%F %T '
end

function backup --argument filename
    cp $filename $filename.bak
end

# Copy DIR1 DIR2
function copy
    set count (count $argv | tr -d \n)
    if test "$count" = 2; and test -d "$argv[1]"
        set from (echo $argv[1] | string trim --right --chars=/)
        set to (echo $argv[2])
        command cp -r $from $to
    else
        command cp $argv
    end
end

# Cleanup local orphaned packages
function cleanup
    while pacman -Qdtq
        sudo pacman -R (pacman -Qdtq)
    end
end

## Useful aliases

# Replace ls with eza
alias l 'eza --color=always --group-directories-first --icons'
alias ls 'eza -al --color=always --group-directories-first --icons' # preferred listing
alias la 'eza -a --color=always --group-directories-first --icons' # all files and dirs
alias ll 'eza -l --color=always --group-directories-first --icons' # long format
alias lt 'eza -aT --color=always --group-directories-first --icons' # tree listing
alias l. 'eza -ald --color=always --group-directories-first --icons .*' # show only dotfiles

# Replace some more things with better alternatives
alias cat 'bat --style header --style snip --style changes --style header'
if not test -x /usr/bin/yay; and test -x /usr/bin/paru
    alias yay paru
end


# Common use
alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'
alias ..... 'cd ../../../..'
alias ...... 'cd ../../../../..'
alias big 'expac -H M "%m\t%n" | sort -h | nl' # Sort installed packages according to size in MB (expac must be installed)
alias dir 'dir --color=auto'
alias fixpacman 'sudo rm /var/lib/pacman/db.lck'
alias gitpkg 'pacman -Q | grep -i "\-git" | wc -l' # List amount of -git packages
alias grep 'ugrep --color=auto'
alias egrep 'ugrep -E --color=auto'
alias fgrep 'ugrep -F --color=auto'
alias grubup 'sudo update-grub'
alias hw 'hwinfo --short' # Hardware Info
alias ip 'ip -color'
alias psmem 'ps auxf | sort -nr -k 4'
alias psmem10 'ps auxf | sort -nr -k 4 | head -10'
alias rmpkg 'sudo pacman -Rdd'
alias tarnow 'tar -acf '
alias untar 'tar -zxvf '
alias upd /usr/bin/garuda-update
alias vdir 'vdir --color=auto'
alias wget 'wget -c '

# Get fastest mirrors
alias mirror 'sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist'
alias mirrora 'sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist'
alias mirrord 'sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist'
alias mirrors 'sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist'

# Help people new to Arch
alias apt 'man pacman'
alias apt-get 'man pacman'
alias please sudo
alias tb 'nc termbin.com 9999'
alias helpme 'echo "To print basic information about a command use tldr <command>"'
alias pacdiff 'sudo -H DIFFPROG=meld pacdiff'

# Get the error messages from journalctl
alias jctl 'journalctl -p 3 -xb'

# Recent installed packages
alias rip 'expac --timefmt="%Y-%m-%d %T" "%l\t%n %v" | sort | tail -200 | nl'

## Run fastfetch if session is interactive
if status --is-interactive && type -q fastfetch
    if test $TERM = xterm-256color
        fastfetch --load-config dr460nized
    else if test $TERM = alacritty
        fastfetch --logo arch
    end
end

### Personal configuration ###
zoxide init fish | source

## Aliases ##
alias cp 'cp -iv'
alias mv 'mv -iv'
alias rm 'rm -v'
alias cl clear
alias todo 'helix --working-dir ~/note/ ~/note/todo.md'
alias note 'helix --working-dir ~/note/'
alias list 'helix /tmp/input_list.txt'
alias fig 'helix --working-dir ~/.config/fish/ ~/.config/fish/config.fish'
alias fp 'ffprobe -hide_banner'
alias erase 'fd -tf -e jpg -e png --exec-batch exiftool -overwrite_original -all= {}' # Remove all image metadata
alias duf 'duf -hide-fs tmpfs,vfat,devtmpfs,efivarfs -hide-mp /,/root,/srv,/var/cache,/var/log,/var/tmp'
alias fzp 'fzf --preview="bat --color=always --style=numbers --line-range=:500 {}" --preview-window="right:50%,border-vertical"'
alias zl zellij
alias zla 'zellij attach'
alias zls 'zellij list-sessions'
alias zld 'zellij delete-session'
alias code 'code --ozone-platform=wayland --enable-wayland-ime'
alias mine 'fd -tf -e mp4 -e mkv --exec chmod -c 600'
alias mna 'mpv --no-resume-playback --no-audio'
alias mnv 'mpv --profile=music --no-video'

# Run the downloader for TVer
if test -d ~/repo/apicall
    alias tver 'poetry run -C ~/repo/apicall/ -vv -- caller'
end

# Show the bus timetable in the terminal
if test -d ~/repo/bttable
    alias btt 'poetry run -C ~/repo/bttable/ -vv -- btt'
end

# Run yt-dlp with the specified profile
function yt
    yt-dlp --config-location ~/.config/yt-dlp/$argv.conf
end

## Git aliases ##
alias gs 'git status --short --branch'
alias ga 'git add'
alias gp 'git push'
alias gr 'git remote -v'
alias gb 'git branch -av'
alias gc 'git commit -v'
alias gd 'git diff'
alias gm 'git merge'
alias gsw 'git switch'
alias gl 'git log --graph --oneline --decorate --all'

## Environment variables ##
set -x EDITOR /usr/bin/helix
set -x VISUAL /usr/bin/helix
set -x BAT_THEME Coldark-Dark
set -x FZF_DEFAULT_COMMAND 'fd --type file --color=always'
set -x FZF_DEFAULT_OPTS '--ansi --reverse'
set -x ELECTRON_OZONE_PLATFORM_HINT wayland

# Rust
if test -d ~/.cargo/bin
    if not contains -- ~/.cargo/bin $PATH
        set -p PATH ~/.cargo/bin
    end
end

# Python Poetry
poetry completions fish >~/.config/fish/completions/poetry.fish

# `yy` shell wrapper that provides the ability
# to change the current working directory when exiting Yazi
function yy
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

## Music utils ##
function play-random-album
    set -l playlist '/tmp/random_album.m3u8'
    fd . -td --min-depth 3 -a ~/Music | shuf >$playlist
    mpv --profile=music $playlist
end

## Wine settings and aliases ##
set -x WINEARCH win32

function fb2k
    set -xl LANG 'ja_JP.UTF-8'
    set -xl WINEPREFIX "$HOME/windows/foobar2000"
    wine "C:\\Program Files\\foobar2000\\foobar2000.exe"
end

function mahjong
    set -xl LANG 'ja_JP.UTF-8'
    set -xl WINEPREFIX "$HOME/game/marujan"
    wine "C:\\Users\\$USER\\Documents\\My Mahjong\\Maru-Jan\\MaruJan.exe"
end

function ffmd
    read -P "Enter title: " title
    read -P "Enter artist(s): " artist
    read -P "Enter destination: " dest

    echo "Please confirm the details:"
    echo "Title: $title"
    echo "Artist: $artist"
    echo "Destination: $dest"

    read -P "\nOverwrite metadata with these values? [Y/n] " confirm

    if test "$confirm" = Y -o "$confirm" = y
        ffmpeg -i $argv -map_metadata -1 -metadata title="$title" -metadata artist="$artist" -c copy "$dest"
    else
        echo "Operation cancelled"
    end
end

# Search and find the exact name of the font family
function fl
    set -l font_family (fc-list : family | fzf)
    wl-copy $font_family
end

# Create or Open Journal
function memo
    set -l notePath "$HOME/note/Journal"
    set -l noteFilename "$notePath/note-$(date +%Y-%m-%d).md"

    if not test -f $noteFilename
        echo "# Notes for $(date +%Y-%m-%d)" >$noteFilename
    end

    helix --working-dir $notePath $noteFilename
end

# Init new repo
function newrepo
    set -l repo_dir "$HOME/repo"
    cd $repo_dir
    poetry new $argv
    cd $argv
    cp ~/Templates/git-ignore/python_gitignore .gitignore
end

# Load wiki function
if test -f ~/script/wiki.fish
    source ~/script/wiki.fish
end
