function tvdl
    # Download videos from TVer using my custom program called `tver-dl`
    # Ensure tver-dl is available
    if not type -q tver-dl
        echo "tver-dl is not installed. Aborting."
        return 1
    end

    set tmpdir (mktemp -dp /tmp yt-dlp.XXXXXX)
    set urlfile "$tmpdir/urls.txt"

    # Fetch URLs and save them to file
    if not tver-dl >$urlfile
        echo "Failed to run tver-dl."
        echo "URL list saved at: $urlfile"
        return 1
    end

    # Stop if the URL file is empty
    if not test -s $urlfile
        echo "Everything is up to date. No new videos found."
        rm -rf $tmpdir
        return 0
    end

    # Download videos using `yt-dlp`
    yt-dlp \
        --ignore-config \
        --config-location ~/.config/tver-dl/yt-dlp.conf \
        --paths "temp: $tmpdir" \
        --batch-file $urlfile

    if test $status -eq 0
        rm -rf $tmpdir
    else
        echo "Download failed. URL list and temporary files are kept at:"
        echo $tmpdir
        return 1
    end
end
