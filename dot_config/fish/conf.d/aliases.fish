## Aliases ##
alias e=yazi
alias hx=helix
alias zl=zellij
alias cat=bat
alias sctl=systemctl

## Replace ls with eza ##
alias ls='eza -al --color=always --group-directories-first --icons' # preferred listing
alias la='eza -a --color=always --group-directories-first --icons' # all files and dirs
alias ll='eza -l --color=always --group-directories-first --icons' # long format
alias lt='eza -T --color=always --group-directories-first --icons --git-ignore' # tree listing
alias l='eza --color=always --group-directories-first --icons --sort Name' # column listing

## Common ##
abbr -a cl clear
abbr -a cp 'cp -iv'
abbr -a mv 'mv -iv'
abbr -a rm 'rm -v'
abbr -a ip 'ip -color=always'
abbr -a mkdir 'mkdir -v'

## Edit Documents ##
abbr -a todo 'helix --working-dir ~/note/ ~/note/todo.md'
abbr -a note 'helix --working-dir ~/note/'
abbr -a fig 'helix --working-dir ~/.config/fish/'

## File Operation ##
abbr -a cz 'chezmoi -v'
abbr -a chmod 'chmod -c'
abbr -a fzp 'fzf --preview="bat --color=always --style=numbers --line-range=:500 {}" --preview-window="right:50%,border-vertical"'
abbr -a erase 'fd -tf -g "*.{png,jpg,jpeg}" -x exiftool -overwrite_original -all= {}' # Remove all image metadata
abbr -a mine 'fd -tf -g "*.{mp4,mkv}" -x chmod -c 0640'
abbr -a mkt 'mktemp -p /tmp'

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
abbr -a duf 'duf -hide-fs vfat,devtmpfs,efivarfs -hide-mp "/,/root,/srv,/dev/shm,/var/*,/run/credentials/*" -theme ansi -style ascii'

## Cleanup ##
abbr -a forget 'qdbus6 org.kde.klipper /klipper org.kde.klipper.klipper.clearClipboardHistory'
abbr -a remove-empty-journal 'fd . -tf --size -23b ~/journal -x rm -v' # Remove journals with header only

## Media Editing ##
abbr -a ffm 'ffmpeg -hide_banner'
abbr -a ffp 'ffprobe -hide_banner'
abbr -a ffshow 'ffprobe -v error -show_streams -select_streams v -of default=noprint_wrappers=1'
abbr -a getfps --set-cursor 'ffprobe -v error -select_streams v -show_entries stream=r_frame_rate -of default=noprint_wrappers=1:nokey=1 % | math'
abbr -a --position anywhere -- -mc '-map_metadata -1 -c copy'

## Media player ##
abbr -a mna 'mpv --no-resume-playback --no-audio'
abbr -a mpm 'mpv --profile=music'
abbr -a rsong --set-cursor 'fd \'\.(m4a|mp3|opus|flac%)$\' -tf -a --base-directory ~/Music/ -X mpv --profile=music --shuffle'

## systemctl ##
abbr -a scs 'systemctl status'
abbr -a scsu 'systemctl status --user'
abbr -a start 'systemctl start'
abbr -a stop 'systemctl stop'
abbr -a mask_service --set-cursor 'systemctl mask %.service'
abbr -a enable 'systemctl enable --now'
abbr -a disable 'systemctl disable --now'
abbr -a reload 'systemctl daemon-reload'
abbr -a timers 'systemctl list-timers -a'
abbr -a units 'systemctl list-unit-files --type=service'

# System updates
abbr -a update 'sudo pacman -Syu'
abbr -a cleanup 'sudo pacman -Rns (pacman -Qdtq)'

## Package management ##
abbr -a search 'pacman -Ss'
abbr -a install 'sudo pacman -S'
abbr -a remove 'sudo pacman -Rns'
abbr -a info 'pacman -Qi'
abbr -a foreign 'pacman -Qm' # Shows packages installed by paru

## AUR helper ##
abbr -a pupdate 'paru -Sua'
abbr -a pclean 'paru -Scc'

## Journal ##
abbr -a jctl 'journalctl -p 3 -xb'
abbr -a jf 'journalctl -f'
abbr -a jeb 'journalctl -eb'
abbr -a jcg --set-cursor 'journalctl -b -g \'%\''

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
abbr -a modupd 'hultra -m "otobot,gb" update --install'
abbr -a modins 'hultra -m "otobot,gb" install'

## Rust ##
abbr -a cb 'cargo build'
abbr -a cbr 'cargo build --release'
abbr -a cr 'cargo run'
abbr -a crr 'cargo run --release'
abbr -a ct 'cargo test'
abbr -a cc 'cargo clippy --all-targets --all-features -- -D warnings'
abbr -a ca 'cargo audit'
