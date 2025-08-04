## Aliases ##

## Common ##
alias e='/usr/bin/yazi'
alias hx='/usr/bin/helix'
alias cz='/usr/bin/chezmoi -v'
alias cl=clear
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -v'
alias ip='ip -color=always'
alias mkdir='mkdir -v'
alias cat='bat --style header --style snip --style changes --style header'

## Edit Documents ##
alias todo='helix --working-dir ~/note/ ~/note/todo.md'
alias note='helix --working-dir ~/note/'
alias fig='helix --working-dir ~/.config/fish/ ~/.config/fish/conf.d/profile.fish'

## File Operation ##
alias chmod='chmod -c'
alias fzp='fzf --preview="bat --color=always --style=numbers --line-range=:500 {}" --preview-window="right:50%,border-vertical"'
abbr -a erase 'fd -tf -e jpg -e png -e jpeg -x exiftool -overwrite_original -all= {}' # Remove all image metadata
abbr -a mine 'fd -tf -e mp4 -e mkv -x chmod -c 0640'

## System Analyze ##
alias du='du -sh'
alias df='df -h'
alias top='btm --basic'
alias htop='btm --basic'
alias memory='free -h'
alias hwinfo='hwinfo --short'
alias glxinfo='glxinfo -B'
alias vulkaninfo='vulkaninfo --summary'

## Replace ls with eza ##
alias ls='eza -al --color=always --group-directories-first --icons' # preferred listing
alias la='eza -a --color=always --group-directories-first --icons' # all files and dirs
alias ll='eza -l --color=always --group-directories-first --icons' # long format
alias lt='eza -aT --color=always --group-directories-first --icons --git-ignore' # tree listing
alias l.="eza -a | grep -e '^\.'" # show only dotfiles
alias l='eza --color=always --group-directories-first --icons --sort Name' # column listing

## Cleanup ##
alias forget='qdbus6 org.kde.klipper /klipper org.kde.klipper.klipper.clearClipboardHistory'
abbr -a remove-empty-journal 'fd . -tf --size -23b ~/journal -x rm -v' # Remove journals with header only

## Media Editing ##
alias ffmpeg='ffmpeg -hide_banner'
alias ffprobe='ffprobe -hide_banner'

## Zellij: Terminal Multiplexer ##
alias zl='/usr/bin/zellij'
alias zla='zellij attach'
alias zls='zellij list-sessions'
alias zld='zellij delete-session'
alias zlk='zellij kill-session'

## systemctl ##
alias timers='systemctl list-timers -a'
alias units='systemctl list-unit-files --type=service'
abbr -a sdr 'sudo systemctl daemon-reload'

## pacman ##
alias uninstall="pacman -Qeq | fzf --multi --preview 'pacman -Qi {}' | xargs -ro sudo pacman -Rns"
alias foreign='pacman -Qm'
abbr -a ditch 'sudo pacman -Rns'

## Network Debugging ##
alias wifi='journalctl -ru iwd.service'
alias adhm='journalctl -ru AdGuardHome.service'

## Journal ##
alias jctl="journalctl -p 3 -xb"
alias jf='journalctl -f'
alias jeb='journalctl -eb'
abbr -a jcg 'journalctl -b -g'

## git ##
alias gs='git status --short --branch'
alias ga='git add'
alias gp='git push'
alias gr='git remote -v'
alias gb='git branch -av'
alias gbd='git branch -D'
alias gc='git commit -v'
alias gd='git diff'
alias gm='git merge'
alias gsw='git switch'
alias gl='git log --graph --oneline --decorate --all'
abbr -a grp 'git reset HEAD~' # Cancel previous commit and revert the commit back to staging area
abbr -a grb 'git rebase -i HEAD~' # Squash multiple commits into one
abbr -a gfp 'git fetch; and git pull' # Fetch and pull (`--prune` is always active in `~/.gitconfig`)

## Celeste ##
abbr -a modup 'hultra -m "wegfan,jade,otobot,gb" update --install'
