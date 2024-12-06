## Wine settings and aliases ##
set -x WINEARCH win32

function fb2k
    set -xl WINEARCH win64
    set -xl LANG 'ja_JP.UTF-8'
    set -xl WINEPREFIX "$HOME/windows/foobar2000-x64_v2.1.6"
    wine "C:\\Program Files\\foobar2000\\foobar2000.exe"
end

function mahjong
    set -xl LANG 'ja_JP.UTF-8'
    set -xl WINEPREFIX "$HOME/game/marujan"
    wine "C:\\Users\\$USER\\Documents\\My Mahjong\\Maru-Jan\\MaruJan.exe"
end
