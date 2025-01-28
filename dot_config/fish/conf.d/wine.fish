## Wine settings and aliases ##

function fb2k
    set --local --export WINEARCH win64
    set --local --export WINEPREFIX "$HOME/windows/foobar2000-x64_v2.24.1"
    wine "C:\\Program Files\\foobar2000\\foobar2000.exe"
end

# function mahjong
#     set --local --export LANG "ja_JP.UTF-8"
#     set --local --export WINEPREFIX "$HOME/game/marujan"
#     wine "C:\\Users\\$USER\\Documents\\My Mahjong\\Maru-Jan\\MaruJan.exe"
# end
