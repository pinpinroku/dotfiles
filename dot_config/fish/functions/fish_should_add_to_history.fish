function fish_should_add_to_history
    # Ignore history settings

    for cmd in exit wiki z ls fastfetch
        string match --quiet --regex "^$cmd" -- $argv; and return 1
    end
    # Check for Japanese characters in arguments
    string match --quiet --regex '[\\p{Han}\\p{Hiragana}\\p{Katakana}]' -- $argv; and return 1
    return 0
end
