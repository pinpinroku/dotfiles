### Initialization ###

## Initial Setup ##

# Starship Prompt
set -gx STARSHIP_CONFIG "$HOME/.config/starship/starship-mokka.toml"

if status --is-interactive
    ## Set vi mode ##
    fish_vi_key_bindings
    set fish_cursor_default block
    set fish_cursor_insert line
    ## init starship ##
    starship init fish | source
    ## init zoxide ##
    zoxide init fish | source
end

# Disable welcome prompt
function fish_mode_prompt
end

### Function ###

## Downloader ##

# Download videos from specific source
function download_videos_from
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
        --config-location "$HOME/.config/yt-dlp/$argv.conf" \
        --path "temp: $tmpdir" \
        --batch-file "$input_file"

    # Delete temporary directory if previous yt-dlp command succeed
    and rm "$tmpdir" -rf
end

# TODO: Might not need this already
# Download video with specific name using aria2c
function dlvid
    yt-dlp --verbose --output "$argv[1].%(ext)s" $argv[2]
end

# Run the downloader for TVer
function tvdl
    if test -d "$HOME/.config/tver-dl"; and type -q tver-dl
        set -l result (tver-dl)
        if not test -z "$result"
            printf "%s\n" $result | tee /dev/tty | yt-dlp_linux \
                --ignore-config \
                --config-location "$HOME/.config/tver-dl/yt-dlp.conf"
        else
            echo "No recent uploads."
        end
    end
end

## File Manager ##
# shell wrapper that provides the ability to change the current working directory when exiting Yazi
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

## Music Utils ##
# Play single album
function select_and_play_album
    set --local music_dir "$HOME/Music"
    set --local min_depth 3

    set --local album_dir (fd . \
        --type directory \
        --color always \
        --min-depth $min_depth \
        $music_dir | fzf --preview 'eza --color=always --tree --icons {}')

    if test -n "$album_dir"
        mpv --profile=music "$album_dir"
    else
        echo "No album selected."
    end
end

# Play random album
function play-random-album
    set --local playlist (mktemp -p '/tmp' --suffix '.m3u8' 'random-playlist.XXXXXXXXXX')
    fd . --type directory --min-depth 3 --absolute-path "$HOME/Music" | shuf >$playlist
    mpv --profile=music $playlist; and rm $playlist
end

## Note Taking ##
# Create or Open Journal
function memo
    set --local notePath "$HOME/journal"
    set --local noteFilename "$notePath/note-$(date +%Y-%m-%d).md"

    if not test -f $noteFilename
        echo "# Notes for $(date +%Y-%m-%d)" >$noteFilename
    end

    helix --working-dir $notePath $noteFilename
end

## Ignore History ##
function fish_should_add_to_history
    for cmd in exit wiki z ls fastfetch
        string match --quiet --regex "^$cmd" -- $argv; and return 1
    end
    # Check for Japanese characters in arguments
    string match --quiet --regex '[\\p{Han}\\p{Hiragana}\\p{Katakana}]' -- $argv; and return 1
    return 0
end

## Decrease clipped audio volume ##
function lower_volume
    ffmpeg -i "$argv" -af 'volume=0.1' -c:v copy "_($argv)"
end
