## Wine settings and aliases ##

function fb2k
    set --local WINEPREFIX "$HOME/windows/foobar2000"
    wine "C:\\Program Files\\foobar2000\\foobar2000.exe"
end

function mahjong
    set --local LANG "ja_JP.UTF-8"
    set --local WINEPREFIX "$HOME/game/marujan"
    wine "C:\\Users\\$USER\\Documents\\My Mahjong\\Maru-Jan\\MaruJan.exe"
end
