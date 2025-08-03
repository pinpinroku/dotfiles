## Wine Configurations ##

# Runs foobar2000 music player through wine
function fb2k
    set --local --export WINEARCH win64
    set --local --export WINEPREFIX "$HOME/windows/foobar2000-x64_v2.24.5"
    wine "C:\\Program Files\\foobar2000\\foobar2000.exe"
end
