## Aliases ##

## Common ##
alias e=yazi
alias cl=clear
alias hx=helix
alias cz='chezmoi -v'
alias cat='bat --style header --style snip --style changes --style header'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -v'
alias ip='ip -color=always'
alias mkdir='mkdir --verbose'

## Edit Documents ##
alias todo='helix --working-dir ~/note/ ~/note/todo.md'
alias note='helix --working-dir ~/note/'
alias fig='helix --working-dir ~/.config/fish/ ~/.config/fish/conf.d/profile.fish'

## File Operation ##
alias erase='fd --type file --extension jpg --extension png --extension jpeg --exec-batch exiftool -overwrite_original -all= {}' # Remove all image metadata
alias fzp='fzf --preview="bat --color=always --style=numbers --line-range=:500 {}" --preview-window="right:50%,border-vertical"'
alias chmod='chmod -c'
abbr -a mine fd -tf -e mp4 -e mkv -x chmod -c 0640

## System Analyze ##
alias du='du -sh'
alias top='btm --basic'
alias htop='btm --basic'
alias memory='free -h'

## eza ##
alias l='eza --color=always --group-directories-first --icons --sort Name'
alias tree='eza --tree --color=always --group-directories-first --icons --git-ignore'
alias lss='eza --long --color=always --group-directories-first --icons --sort size'

## Cleanup ##
alias forget='qdbus6 org.kde.klipper /klipper org.kde.klipper.klipper.clearClipboardHistory'
alias remove-empty-journal='fd . --type file --size -23b ~/journal -X rm -v'

## Media Editing ##
alias ffmpeg='ffmpeg -hide_banner'
alias ffprobe='ffprobe -hide_banner'

## Zellij ##
alias zl=zellij
alias zla='zellij attach'
alias zls='zellij list-sessions'
alias zld='zellij delete-session'
alias zlk='zellij kill-session'

## systemctl ##
alias timers='systemctl list-timers -a'
alias units='systemctl list-unit-files --type=service'
alias sdr='sudo systemctl daemon-reload'

## pacman ##
alias uninstall="pacman -Qeq | fzf --multi --preview 'pacman -Qi {}' | xargs -ro sudo pacman -Rns"
alias foreign='pacman -Qm'

## Network Debugging ##
alias wifi='journalctl -fu iwd.service'
alias adhm='journalctl -fu AdGuardHome.service'

## Journal ##
alias jf='journalctl -f'
alias jeb='journalctl -eb'
abbr -a jcg journalctl -b -g

## git ##
alias gs='git status --short --branch'
alias ga='git add'
alias gp='git push'
alias gr='git remote -v'
alias gb='git branch -av'
alias gc='git commit -v'
alias gd='git diff'
alias gm='git merge'
alias gsw='git switch'
alias gl='git log --graph --oneline --decorate --all'
alias grp='git reset HEAD~' # Cancel previous commit and revert the commit back to staging area
