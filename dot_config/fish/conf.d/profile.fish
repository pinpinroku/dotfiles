### Initialization ###


### Environment Variable ###

set -x EDITOR /usr/bin/helix
set -x VISUAL /usr/bin/helix
set -x FZF_DEFAULT_COMMAND 'fd --type file --strip-cwd-prefix --hidden --follow --exclude .git --color=always'
set -x FZF_DEFAULT_OPTS '--ansi --reverse'
set -x STARSHIP_CONFIG ~/.config/starship/starship.toml


## Initial Setup ##

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

alias e yazi
alias cl clear
alias hx /usr/bin/helix
alias cz /usr/bin/chezmoi
alias cat 'bat --style header --style snip --style changes --style header'
alias l 'eza --color=always --group-directories-first --icons --sort Name'
alias lss 'eza --long --color=always --group-directories-first --icons --sort size'
alias cp 'cp --interactive --verbose'
alias mv 'mv --interactive --verbose'
alias rm 'rm --verbose'
alias ip 'ip -color=always'
alias mkdir 'mkdir --verbose'
alias todo 'helix --working-dir ~/note/ ~/note/todo.md'
alias note 'helix --working-dir ~/note/'
alias list 'helix /tmp/input_list.txt'
alias fig 'helix --working-dir ~/.config/fish/ ~/.config/fish/conf.d/profile.fish'
alias conf 'helix --working-dir ~/.config/'
alias ffmpeg 'ffmpeg -hide_banner'
alias fp 'ffprobe -hide_banner'
alias fpm 'ffprobe -hide_banner -v error -show_entries format_tags -show_entries stream_tags -of default=noprint_wrappers=1'
alias erase 'fd --type file --extension jpg --extension png --extension jpeg --exec-batch exiftool -overwrite_original -all= {}' # Remove all image metadata
alias duf 'duf -hide-fs tmpfs,vfat,devtmpfs,efivarfs -hide-mp /,/root,/srv,/var/cache,/var/log,/var/tmp -theme dark -style ascii'
alias fzp 'fzf --preview="bat --color=always --style=numbers --line-range=:500 {}" --preview-window="right:50%,border-vertical"'
alias mine 'fd --type file --extension mp4 --extension mkv --exec chmod --changes 0600'
alias htop 'btm --basic'

## mpv ##
alias mna 'mpv --no-resume-playback --no-audio'
alias mpm 'mpv --profile=music'
alias album 'mpv --profile=music (fd . --type directory --color always --min-depth 3 ~/Music | fzf)'

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
alias paqe 'pacman -Qe'

## NetworkManager ##
alias ngs 'nmcli general status'
alias ndshow 'nmcli device show'
alias ndstat 'nmcli device status'

## Network Debugging ##
alias ntwk 'journalctl -fu NetworkManager.service'
alias adhm 'journalctl -fu AdGuardHome.service'

## Journal ##
alias jf 'journalctl -f'
alias jeb 'journalctl -eb'

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


### Function ###

# Run yt-dlp with the specified profile
function yt
    yt-dlp --config-location ~/.config/yt-dlp/$argv.conf
end

## Downloader ##
# Run the downloader for TVer
function tvdl
    if test -d ~/.config/tver-dl; and type -q tver-dl
        set -l result (tver-dl)
        if not test -z "$result"
            printf "%s\n" $result | tee /dev/tty | yt-dlp --config-location ~/.config/tver-dl/yt-dlp.conf
        else
            echo "No recent uploads."
        end
    end
end

## File Manager ##
# shell wrapper that provides the ability to change the current working directory when exiting Yazi
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

## Music Utils ##
function play-random-album
    set --local playlist '/tmp/random_album.m3u8'
    fd . --type directory --min-depth 3 --absolute-path ~/Music | shuf >$playlist
    mpv --profile=music $playlist
end

## Note Taking ##
# Create or Open Journal
function memo
    set --local notePath "$HOME/journal"
    set --local noteFilename "$notePath/note-$(date +%Y-%m-%d).md"

    if not test -f $noteFilename
        echo "# Notes for $(date +%Y-%m-%d)" >$noteFilename
    end

    helix --working-dir $notePath $noteFilename
end

## Virtual Machine ##
function runvm
    set --local path_to_image $argv[1]
    if test -z "$path_to_image"
        set path_to_image "$HOME/vm/img/cachyos.qcow2"
    end
    qemu-system-x86_64 -hda "$path_to_image" \
        -accel kvm \
        -cpu host \
        -smp cores=12 \
        -m 16G \
        -vga virtio \
        -audio pipewire,model=virtio \
        -nic user,ipv6=off,hostfwd=tcp::8888-:22 \
        -full-screen
end
