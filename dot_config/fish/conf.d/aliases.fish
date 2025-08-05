## Common ##
abbr -a e /usr/bin/yazi
abbr -a hx /usr/bin/helix
abbr -a cz '/usr/bin/chezmoi -v'
abbr -a c =clear
abbr -a cp 'cp -iv'
abbr -a mv 'mv -iv'
abbr -a rm 'rm -v'
abbr -a ip 'ip -color=always'
abbr -a mkdir 'mkdir -v'
abbr -a cat 'bat --style header --style snip --style changes --style header'
abbr -a fd 'fd -c always'

## Edit Documents ##
abbr -a todo 'helix --working-dir ~/note/ ~/note/todo.md'
abbr -a note 'helix --working-dir ~/note/'
abbr -a fig 'helix --working-dir ~/.config/fish/ ~/.config/fish/conf.d/profile.fish'

## File Operation ##
abbr -a chmod 'chmod -c'
abbr -a fzp 'fzf --preview="bat --color=always --style=numbers --line-range=:500 {}" --preview-window="right:50%,border-vertical"'
abbr -a erase 'fd -tf -g "*.{png,jpg,jpeg}" -x exiftool -overwrite_original -all= {}' # Remove all image metadata
abbr -a mine 'fd -tf -g "*.{mp4,mkv}" -x chmod -c 0640'
abbr -a mkt 'mktemp -p /tmp '

## System Analyze ##
abbr -a df 'df -h'
abbr -a du 'du -sh'
abbr -a top 'btm --basic'
abbr -a htop 'btm --basic'
abbr -a dust 'dust -b --skip-total'
abbr -a memory 'free -h'
abbr -a hwinfo 'hwinfo --short'
abbr -a glxinfo 'glxinfo -B'
abbr -a vulkaninfo 'vulkaninfo --summary'
abbr -a duf \
    'duf \
    -hide-fs vfat,devtmpfs,efivarfs \
    -hide-mp "/,/root,/srv,/dev/shm,/var/*,/run/credentials/*" \
    -theme ansi \
    -style ascii'

## Replace ls with eza ##
alias ls='eza -al --color=always --group-directories-first --icons' # preferred listing
alias la='eza -a --color=always --group-directories-first --icons' # all files and dirs
alias ll='eza -l --color=always --group-directories-first --icons' # long format
alias lt='eza -T --color=always --group-directories-first --icons --git-ignore' # tree listing
alias l='eza --color=always --group-directories-first --icons --sort Name' # column listing

## Cleanup ##
abbr -a forget 'qdbus6 org.kde.klipper /klipper org.kde.klipper.klipper.clearClipboardHistory'
abbr -a remove-empty-journal 'fd . -tf --size -23b ~/journal -x rm -v' # Remove journals with header only

## Media Editing ##
alias ffmpeg='ffmpeg -hide_banner'
alias ffprobe='ffprobe -hide_banner'

## Media player ##
abbr -a mna 'mpv --no-resume-playback --no-audio'
abbr -a mpm 'mpv --profile=music'

## Zellij: Terminal Multiplexer ##
alias zl='/usr/bin/zellij'
abbr -a zla 'zellij attach'
abbr -a zls 'zellij list-sessions'
abbr -a zld 'zellij delete-session'
abbr -a zlk 'zellij kill-session'

## systemctl ##
abbr -a timers 'systemctl list-timers -a'
abbr -a units 'systemctl list-unit-files --type=service'
abbr -a sdr 'sudo systemctl daemon-reload'

## pacman ##
abbr -a uninstall "pacman -Qeq | fzf --multi --preview 'pacman -Qi {}' | xargs -ro sudo pacman -Rns"
abbr -a foreign 'pacman -Qm'
abbr -a ditch 'sudo pacman -Rns'
abbr -a search "pacman -Slq | fzf --multi --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S"
abbr -a lookup "pacman -Qeq | fzf --multi --preview 'pacman -Qi {}'"

## Journal ##
abbr -a jctl 'journalctl -p 3 -xb'
abbr -a jf 'journalctl -f'
abbr -a jeb 'journalctl -eb'
abbr -a jcg --ser-cursor 'journalctl -b -g \'%\''

## Network Debugging ##
abbr -a wifi 'journalctl -b -eu iwd.service'
abbr -a adhm 'journalctl -b -eu AdGuardHome.service'
abbr -a ports 'ss -tulne4'

## git ##
abbr -a gs 'git status --short --branch'
abbr -a ga 'git add'
abbr -a gp 'git push'
abbr -a gr 'git remote -v'
abbr -a gb 'git branch -av'
abbr -a gbd 'git branch -D'
abbr -a gc 'git commit -v'
abbr -a gd 'git diff'
abbr -a gm 'git merge'
abbr -a gsw 'git switch'
abbr -a gl 'git log --graph --oneline --decorate --all'
abbr -a grp 'git reset HEAD~' # Cancel previous commit and revert the commit back to staging area
abbr -a grb 'git rebase -i HEAD~' # Squash multiple commits into one
abbr -a gfp 'git fetch; and git pull' # Fetch and pull (`--prune` is always active in `~/.gitconfig`)

## Virtual Machine ##
abbr -a qimg --set-cursor 'qemu-img create -f qcow2 %.qcow2 -o nocow=on 50G'

## Celeste ##
abbr -a modupd 'hultra -m "wegfan,jade,otobot,gb" update --install'
abbr -a modins 'hultra -m "wegfan,jade,otobot,gb" install '
