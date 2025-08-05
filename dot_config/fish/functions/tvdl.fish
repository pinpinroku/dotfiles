function tvdl
    # Download videos from TVer using my custom program called `tver-dl`

    if not test -d ~/.config/tver-dl; and type -q tver-dl
        echo "You do not have tver-dl installed. Command canceled."
        return 1
    end

    set result (tver-dl)
    if test -z $result
        echo "No recent uploads. You are up-to-date!"
    end

    set tmpdir (mktemp -dp '/tmp' 'yt-dlp.XXXXXX')

    printf "%s\n" $result | tee /dev/tty | yt-dlp_linux \
        --ignore-config \
        --config-location ~/.config/tver-dl/yt-dlp.conf \
        --paths "temp: $tmpdir" \
        --batch-file -

    and rm -rf $tmpdir
end
