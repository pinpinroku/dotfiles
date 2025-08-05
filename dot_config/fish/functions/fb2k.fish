function fb2k
    # Launch foobar2000 through wine

    set -lx WINEARCH win64
    set -lx WINEPREFIX ~/windows/foobar2000-x64_v2.24.5
    wine 'C:\\Program Files\\foobar2000\\foobar2000.exe'
end
