function backup_to_hdd
    # Backup specific symlinked user data to the external HDD
    # NOTE: Creates symbolic links of desired data to the `$bakdir` before running this script

    # Define backup directory name
    set bakdir backup

    # WARNING: Do not forget to add trailing slash to the paths
    set source "$HOME/$bakdir/"
    set dest "/run/media/$USER/Backups/$bakdir/"

    if not test -e $source; or not test -e $dest
        echo "⛔ One or both paths are missing. Make sure the HDD is mounted."
        return 1
    end

    # Define basic options for rsync
    set RSYNC_BASE_OPTS -avhXL "--filter=:- .gitignore" --delete

    # Shows changes will be made before performing back up
    echo "📜 The following changes will be made:"
    rsync $RSYNC_BASE_OPTS --dry-run --itemize-changes $source $dest
    or begin
        echo "🛑 Dry run failed with status $status"
        return 1
    end

    echo -e "\n🪧 Do you want to proceed with these changes? (y/n)"
    read -l answer
    if string match -iq y $answer
        rsync $RSYNC_BASE_OPTS --info=progress2 $source $dest
    else
        echo "↩️ Operation cancelled by user"
    end
end
