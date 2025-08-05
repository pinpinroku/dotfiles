function play-random-album
    # Plays random album
    # Shuffling the results and save it to the playlist file

    set playlist (mktemp -p /tmp --suffix '.m3u8' 'random-playlist.XXXXXXXXXX')
    fd . -td --exact-depth 3 -a ~/Music | shuf >$playlist
    and mpv --profile=music $playlist

    and rm $playlist
end
