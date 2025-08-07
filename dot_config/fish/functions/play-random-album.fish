function play-random-album
    # Plays random album
    # Shuffling the results and save it to the playlist file
    # NOTE: ~/Music should be following structure: ./Artist/Album/Song

    set playlist (mktemp -p /tmp --suffix '.m3u8' 'random-playlist.XXXXXXXXXX')
    fd . -td --exact-depth 2 -a ~/Music | shuf >$playlist
    mpv --profile=music $playlist

    and rm $playlist
end
