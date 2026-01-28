function shuffle_album_and_play
    ## play random album by mpc ##

    mpc clear
    mpc add (fd . --base-directory "$HOME/Music" -td --exact-depth 2 | shuf -n 5)
    mpc play
end
