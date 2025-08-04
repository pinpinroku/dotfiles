# mpv
abbr -a -- mna 'mpv --no-resume-playback --no-audio'
abbr -a -- mpm 'mpv --profile=music'

# pacman
abbr -a -- search "pacman -Slq | fzf --multi --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S"
abbr -a -- lookup "pacman -Qeq | fzf --multi --preview 'pacman -Qi {}'"

# Network utils
abbr -a -- ports 'ss -tulne4'

# Disk usage
abbr -a -- duf \
    'duf \
    -hide-fs vfat,devtmpfs,efivarfs \
    -hide-mp "/,/root,/srv,/dev/shm,/var/*,/run/credentials/*" \
    -theme ansi \
    -style ascii'
