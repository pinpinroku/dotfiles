### Initialization ###

# Initialize starship prompt and zoxide
if status --is-interactive
    # Set vi mode
    fish_vi_key_bindings
    set fish_cursor_default block
    set fish_cursor_insert line
    # init starship
    starship init fish | source
    # init zoxide
    zoxide init fish | source
end


### Alias ###

alias cat 'bat --style header --style snip --style changes --style header'
alias l 'eza --color=always --group-directories-first --icons --no-quotes --sort Name'
alias e yazi
alias cl clear
alias cp 'cp -iv'
alias mv 'mv -iv'
alias rm 'rm -v'
alias mkdir 'mkdir -v'
alias todo 'helix --working-dir ~/note/ ~/note/todo.md'
alias note 'helix --working-dir ~/note/'
alias list 'helix /tmp/input_list.txt'
alias fig 'helix --working-dir ~/.config/fish/ ~/.config/fish/conf.d/profile.fish'
alias fp 'ffprobe -hide_banner'
alias erase 'fd -tf -e jpg -e png -e jpeg --exec-batch exiftool -overwrite_original -all= {}' # Remove all image metadata
alias duf 'duf -hide-fs tmpfs,vfat,devtmpfs,efivarfs -hide-mp /,/root,/srv,/var/cache,/var/log,/var/tmp -theme dark -style ascii'
alias fzp 'fzf --preview="bat --color=always --style=numbers --line-range=:500 {}" --preview-window="right:50%,border-vertical"'
alias mine 'fd -tf -e mp4 -e mkv --exec chmod -c 600'

## mpv ##
alias mna 'mpv --no-resume-playback --no-audio'
alias mnv 'mpv --profile=music --no-video'
alias album 'mpv --profile=music (fd . -td --color always --min-depth 3 ~/Music | fzf)'

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
alias timers 'systemctl list-timers -a'
alias unit-files 'systemctl list-unit-files --type=service'

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
function tvdl
    if test -d ~/.config/tver-dl
        if type -q tver-dl
            tver-dl | tee /dev/tty | yt-dlp --config-location ~/.config/tver-dl/yt-dlp.conf
        end
    end
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

## VM ##
alias cachy "qemu-system-x86_64 -hda $HOME/Documents/vm/cachyos/kdeplasma.img -m 8G -smp 12 -accel kvm -vga virtio"


### Environment Variable ###

set -x EDITOR /usr/bin/helix
set -x VISUAL /usr/bin/helix
# set -x BAT_THEME 'Catppuccin Mocha'
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

### Function ###

# Run yt-dlp with the specified profile
function yt
    yt-dlp --config-location ~/.config/yt-dlp/$argv.conf
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

## Note Taking ##
# Create or Open Journal
function memo
    set -l notePath "$HOME/journal"
    set -l noteFilename "$notePath/note-$(date +%Y-%m-%d).md"

    if not test -f $noteFilename
        echo "# Notes for $(date +%Y-%m-%d)" >$noteFilename
    end

    helix --working-dir $notePath $noteFilename
end

if status --is-interactive && type -q fastfetch
    if test $TERM = alacritty
        fastfetch --logo arch
    else
        fastfetch --load-config dr460nized
    end
end

set -x STARSHIP_CONFIG ~/.config/starship/powerline.toml
