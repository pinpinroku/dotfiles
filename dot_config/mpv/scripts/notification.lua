function on_file_loaded()
    local path = mp.get_property("path")
    local audio_extensions = {".mp3", ".opus", ".flac", ".m4a"}
    local is_audio = false

    for _, ext in ipairs(audio_extensions) do
        if string.lower(path:sub(-#ext)) == ext then
            is_audio = true
            break
        end
    end

    if is_audio then
        local title = mp.get_property("media-title") or "不明なタイトル"
        local artist = mp.get_property("metadata/by-key/Artist") or "不明なアーティスト"
        local album = mp.get_property("metadata/by-key/Album") or "不明なアルバム"
        local year = mp.get_property("metadata/by-key/Date") or "発売日不明"
        
        local message = string.format("%s\n%s - %s (%s)", title, artist, album, year)
        
        os.execute(string.format("notify-send -a 'Now Playing' --hint=string:desktop-entry:mpv '%s'", message))
    end
end

mp.register_event("file-loaded", on_file_loaded)
