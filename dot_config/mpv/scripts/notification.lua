-- Lua script for mpv to send desktop notifications using notify-send for audio files only

local mp = require 'mp'
local utils = require 'mp.utils'

-- List of audio file extensions to trigger notifications
local audio_extensions = {
    [".mp3"] = true,
    [".m4a"] = true,
    [".opus"] = true,
    [".flac"] = true,
    [".wav"] = true
}

-- Function to check if the file is an audio file based on extension
local function is_audio_file(filename)
    if not filename then return false end
    local ext = filename:lower():match("^.+(%.%w+)$")  -- Extract extension (e.g., .mp3)
    return audio_extensions[ext] or false
end

-- Function to send a notification using notify-send
local function send_notification(track, title, artist, album)
    -- Default values if metadata is missing
    track = tonumber(track) or 1  -- Convert to number, default to 1 if nil or invalid
    title = title or "Unknown Title"
    artist = artist or "Unknown Artist"
    album = album or "Unknown Album"

    -- Format track number with # and padding (e.g., #01)
    local track_str = string.format("%02d", track)

    -- Construct the notification body
    local body = string.format(" 🎵%s %s\n 👤%s\n 💿%s", track_str, title, artist, album)

    -- Use notify-send to display the notification with mpv icon
    utils.subprocess({
        args = {
            "notify-send",
            "-a", "MPV - Now Playing",  -- Title of the notification
            "-t", "10000",   -- Duration in milliseconds (10 seconds)
            "--hint=string:desktop-entry:mpv",
            "-i", "mpv",    -- Icon name (assumes 'mpv' icon is available)
            body,           -- Body of the notification
        },
        cancellable = false
    })
end

-- Function to get metadata and trigger notification
local function on_file_loaded()
    -- Get the filename to check its extension
    local filename = mp.get_property("filename")

    -- Only proceed if it's an audio file
    if is_audio_file(filename) then
        -- Get metadata from mpv
        local track = mp.get_property("metadata/track")
        local title = mp.get_property("metadata/title")
        local artist = mp.get_property("metadata/artist")
        local album = mp.get_property("metadata/album")

        -- Send the notification
        send_notification(track, title, artist, album)
    end
end

-- Register the event for when a new file is loaded
mp.register_event("file-loaded", on_file_loaded)
