function select_and_play_album
    # Play single album by selecting interactively

    cd ~/Music
    set preview 'eza -T --color=always --icons {}'
    set album_dir (fd --color always -td --exact-depth 2 | fzf --preview $preview )
    and mpv --profile=music $album_dir
end
