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

## Useful aliases ##

# Replace ls with eza
alias l 'eza --color=always --group-directories-first --icons --no-quotes --sort Name'
alias ls 'exa -al --color=always --group-directories-first --icons --sort Name --color-scale size --color-scale-mode gradient --no-quotes ' # preferred listing
alias la 'exa -a --color=always --group-directories-first --icons --sort Name' # all files and dirs
alias ll 'exa -l --color=always --group-directories-first --icons --sort Name --color-scale size --color-scale-mode gradient --no-quotes ' # long format
alias lt 'exa -aT --color=always --group-directories-first --icons --no-quotes --sort Name' # tree listing
alias l. 'exa -ald --color=always --group-directories-first --icons .* --no-quotes --sort Name' # show only dotfiles


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
    fastfetch --logo arch
end

### Personal Configurations ###
# Initialize starship prompt
starship init fish | source
set -x STARSHIP_CONFIG = '~/.config/alacritty/starship.toml'

# Initialize zoxide
zoxide init fish | source

## Aliases ##
alias c clear
alias h history
alias y yazi
alias cp 'cp -iv'
alias mv 'mv -iv'
alias rm 'rm -v'
alias todo 'helix --working-dir ~/note/ ~/note/todo.md'
alias note 'helix --working-dir ~/note/'
alias list 'helix /tmp/input_list.txt'
alias fig 'helix --working-dir ~/.config/fish/ ~/.config/fish/config.fish'
alias fp 'ffprobe -hide_banner'
alias erase 'fd -tf -e jpg -e png -e jpeg --exec-batch exiftool -overwrite_original -all= {}' # Remove all image metadata
alias duf 'duf -hide-fs tmpfs,vfat,devtmpfs,efivarfs -hide-mp /,/root,/srv,/var/cache,/var/log,/var/tmp -theme ansi'
alias fzp 'fzf --preview="bat --color=always --style=numbers --line-range=:500 {}" --preview-window="right:50%,border-vertical"'
alias mine 'fd -tf -e mp4 -e mkv --exec chmod -c 600'

## mpv ##
alias mna 'mpv --no-resume-playback --no-audio'
alias mnv 'mpv --profile=music --no-video'

## Zellij ##
alias zl zellij
alias zla 'zellij attach'
alias zls 'zellij list-sessions'
alias zld 'zellij delete-session'
alias zlk 'zellij kill-session'

## systemctl ##
alias systat 'systemctl status'
alias systatu 'systemctl status --user'
alias systop 'systemctl stop'
alias systopu 'systemctl stop --user'
alias systart 'systemctl start'
alias systartu 'systemctl start --user'
alias sysres 'systemctl restart'
alias sysresu 'systemctl restart --user'
alias sysrel 'systemctl reload'
alias sysrelu 'systemctl reload --user'
alias sysdmr 'sudo systemctl daemon-reload'

## pacman ##
alias pass 'pacman -Ss'
alias pasi 'pacman -Si'
alias paqs 'pacman -Qs'
alias paqi 'pacman -Qi'

## NetworkManager ##
alias ngs 'nmcli general status'
alias ndshow 'nmcli device show'
alias ndstat 'nmcli device status'
alias cons 'nmcli connection show "Wired connection 1"'

## Network Debugging ##
alias ntwk 'journalctl -fu NetworkManager.service'
alias adhm 'journalctl -fu AdGuardHome.service'

## Journal ##
alias jf 'journalctl -f'
alias jeb 'journalctl -eb'

## Downloader ##
# Run the downloader for TVer
alias tvdl 'tver-dl | tee /dev/tty | yt-dlp --config-location ~/.config/tver-dl/yt-dlp.conf'

# Run yt-dlp with the specified profile
function yt
    yt-dlp --config-location ~/.config/yt-dlp/$argv.conf
end

## git ##
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

## Environment Variables ##
set -x EDITOR /usr/bin/helix
set -x VISUAL /usr/bin/helix
set -x BAT_THEME 'Catppuccin Mocha'
set -x FZF_DEFAULT_COMMAND 'fd --type file --strip-cwd-prefix --hidden --follow --exclude .git --color=always'
set -x FZF_DEFAULT_OPTS '--ansi --reverse'
# set -x ELECTRON_OZONE_PLATFORM_HINT wayland

## Rust-Lang ##
# Add the path of cargo to the $PATH
if test -d ~/.cargo/bin
    if not contains -- ~/.cargo/bin $PATH
        set -p PATH ~/.cargo/bin
    end
end

## File Manager ##
# `yy` shell wrapper that provides the ability to change the current working directory when exiting Yazi
function yy
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

## Music Utils ##
function play-random-album
    set -l playlist '/tmp/random_album.m3u8'
    fd . -td --min-depth 3 -a ~/Music | shuf >$playlist
    mpv --profile=music $playlist
end

## Wine settings and aliases ##
set -x WINEARCH win32

function fb2k
    set -xl WINEARCH win64
    set -xl LANG 'ja_JP.UTF-8'
    set -xl WINEPREFIX "$HOME/windows/foobar2000-x64_v2.1.6"
    wine "C:\\Program Files\\foobar2000\\foobar2000.exe"
end

function mahjong
    set -xl LANG 'ja_JP.UTF-8'
    set -xl WINEPREFIX "$HOME/game/marujan"
    wine "C:\\Users\\$USER\\Documents\\My Mahjong\\Maru-Jan\\MaruJan.exe"
end

## Font Management ##
# Search and find the exact name of the font family
function fl
    set -l font_family (fc-list : family | fzf)
    wl-copy $font_family
end

## Note Taking ##
# Create or Open Journal
function memo
    set -l notePath "$HOME/note/Journal"
    set -l noteFilename "$notePath/note-$(date +%Y-%m-%d).md"

    if not test -f $noteFilename
        echo "# Notes for $(date +%Y-%m-%d)" >$noteFilename
    end

    helix --working-dir $notePath $noteFilename
end
