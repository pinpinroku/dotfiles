function select_and_play_album
    # Play single album by selecting interactively

    set preview 'eza -T --color=always --icons {}'
    set album_dir (fd . -td --exact-depth 3 ~/Music | fzf --preview $preview )
    and mpv --profile=music $album_dir
end
