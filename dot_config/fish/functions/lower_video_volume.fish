function lower_video_volume
    # Decreases clipped audio in the given video

    set file $argv[1]
    set output "$(path basename -E $file).tmp.mp4"
    ffmpeg -i $file -af 'volume=0.1' -c:v copy $output
    and mv $file{,.bak}
    and mv $output $file
end
