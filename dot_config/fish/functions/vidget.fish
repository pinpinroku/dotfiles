function vidget
    # Description: Download a video using m3u8 file. Then remove fake PNG header and merge them into mp4.
    # 
    # Dependencies:
    # - fish >= 4.0.2
    # - curl >= 8.15.0
    # - ffmpeg >= 7.1.1
    # - sd >= 1.0.0

    function usage
        set script (basename (status -f))
        echo "Usage: $script <output_name> <PLAYLIST_URL.m3u8>"
    end

    if test (count $argv) -ne 2
        usage
        return 1
    end

    set OUTPUT_NAME $argv[1]
    set PLAYLIST_URL $argv[2]

    # Define REFERER by extracting Origin from the given m3u8 URL
    string match -rq '(?<REFERER>https://[^/:]+)/.+\.m3u8$' $PLAYLIST_URL
    or begin
        echo "Could not extracting Origin from given URL. Make sure the playlist URL ends with '.m3u8'."
        return 1
    end
    echo "📣 REFERER: $REFERER"

    # Check for required tools
    for cmd in curl ffmpeg sd
        if not type -q $cmd
            echo "⛔ Required command '$cmd' not found."
            return 2
        end
    end

    # Pick a random User-Agent
    set user_agents \
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:141.0) Gecko/20100101 Firefox/141.0" \
        "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36" \
        "Mozilla/5.0 (X11; Linux x86_64; rv:141.0) Gecko/20100101 Firefox/141.0" \
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 15_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.4 Safari/605.1.15" \
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 15.6; rv:141.0) Gecko/20100101 Firefox/141.0" \
        "Mozilla/5.0 (X11; CrOS x86_64 16181.61.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.6998.198 Safari/537.36"
    set random_agent (random choice $user_agents)
    echo "📣 User-Agent: $random_agent"

    # Creates a temporary directory
    set tmpdir (mktemp -dp '/tmp')
    echo "📂 Temporary directory created at: $tmpdir"

    echo "📥 Downloading m3u8 playlist..."
    set base (path basename $PLAYLIST_URL)
    set PLAYLIST_FILE "$tmpdir/$base"
    and curl -fsSL4 --http3 --compressed --referer $REFERER $PLAYLIST_URL -o $PLAYLIST_FILE

    echo "🔧 Generating URL list..."
    set curl_config "$tmpdir/urls.txt"
    set -e filenames
    for line in (string match -r '^https://.*' <$PLAYLIST_FILE)
        set fname (path basename $line)
        set -a filenames $fname
        echo "url = \"$line\"" >>$curl_config
    end

    set total (count $filenames)
    set parallel_limit (random 20 35)
    echo "📥 Downloading $total fragments using $parallel_limit threads..."
    and curl \
        --fail \
        --retry 5 \
        --retry-delay 2 \
        --ipv4 \
        --http2 \
        --referer $REFERER \
        --user-agent $random_agent \
        --remote-name-all \
        --output-dir $tmpdir \
        --parallel \
        --parallel-max $parallel_limit \
        --write-out "%{stderr}%output{>>$tmpdir/errors.log}%{url_effective} %{exitcode}\n" \
        --config $curl_config

    # Extract URLs where `exit code != 0`
    set failed_urls (string match -rg '^(https://.+)\s(?!0$)\d+' <"$tmpdir/errors.log")

    if test (count $failed_urls) -ne 0
        echo "⚠️ Some fragments failed to download. Retrying them one by one..."

        set -l retry_limit 5
        set -l delay_sec 5
        set -e final_failures

        for url in $failed_urls
            set -l success false
            for i in (seq 1 $retry_limit)
                echo "🔁 Retry [$i/$retry_limit]: $url"
                if curl -fLO --retry 3 --retry-delay 1 --ipv4 --http2 --output-dir $tmpdir $url
                    echo "✅ Success: $url"
                    set success true
                    break
                else
                    echo "❌ Failed: $url (retry $i)"
                    sleep $delay_sec
                end
            end

            if not $success
                echo "💥 Permanent failure: $url"
                set -a final_failures $url
            end
        end

        # Still fails, exit with error code 1
        if test (count $final_failures) -gt 0
            echo "🛑 Some fragments still failed after retry:"
            for f in $final_failures
                echo " - $f"
            end
            return 1
        end
    end

    # TODO: Checks first file whether it contains PNG signatur on the first 8 bytes
    echo "🔧 Removing fake PNG header..."
    for fname in $filenames
        set fname "$tmpdir/$fname"
        tail -c +71 $fname >"$fname.ts"; and command rm $fname
    end

    # Reaname playlist paths
    echo "🔧 Updating playlist with local TS filenames..."
    and sd '^https://.+/(\w+)$' '$1.ts' $PLAYLIST_FILE

    # Merge files
    echo "🎬 Merging TS files into MP4..."
    and ffmpeg -y \
        -hide_banner \
        -loglevel warning \
        -fflags +genpts \
        -avoid_negative_ts make_non_negative \
        -i $PLAYLIST_FILE \
        -c copy \
        -bsf:a aac_adtstoasc \
        "$HOME/Downloads/$OUTPUT_NAME.mp4"

    and begin
        command rm -rf $tmpdir
        echo "✅ $OUTPUT_NAME.mp4 created."
    end
end
