function select_and_play_album
    # Play single album by selecting interactively

    cd ~/Music
    set preview 'eza -T --color=always --icons {}'
    set album_dir (fd -td --exact-depth 2 -c always | fzf --preview $preview )
    and mpv --profile=music $album_dir
end
