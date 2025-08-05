function download_videos_from
    # Downloads videos from specific source
    # Valid argument is one of: "tver", "audio", and "tube"
    # These confi files must defined in ~/.config/yt-dlp

    # Check if an argument is provided
    if test (count $argv) -eq 0
        echo "Error: No configuration name provided. Please specify one of: tver, audio, tube."
        return 1
    end

    # Define valid config file names
    set -l valid_configs tver audio tube

    # Check if the provided argument is valid
    if not contains $argv $valid_configs
        echo "Error: Invalid configuration name '$argv'. Valid options are: $valid_configs."
        return 1
    end

    # Creates temporary directory and the file to write URLs
    set -l tmpdir (mktemp -dp '/tmp' 'yt-dlp.XXXXXXXXXX')
    set -l input_file (mktemp -p "$tmpdir" --suffix '.txt' 'url-list.XXXXXXXXXX')

    # Open the file to edit URLs
    $EDITOR $input_file

    # Download videos with yt-dlp using specific config file
    yt-dlp_linux \
        --ignore-config \
        --config-location ~/.config/yt-dlp/$argv.conf \
        --path "temp: $tmpdir" \
        --batch-file $input_file

    # Delete temporary directory if previous yt-dlp command succeed
    and rm $tmpdir -rf
end
