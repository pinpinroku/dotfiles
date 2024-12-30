#!/usr/bin/env bash

# Define the directory for themes
theme_dir="$(bat --config-dir)/themes"

# Base URL for the themes
base_url="https://github.com/catppuccin/bat/raw/main/themes"

# Use globbing to download multiple themes and specify output filenames
curl -L -o "$theme_dir/Catppuccin #1.tmTheme" "$base_url/Catppuccin%20{Frappe,Macchiato,Mocha}.tmTheme"

if [ $? -eq 0 ]; then
  bat cache --build
else
  echo "Failed to download themes. Building cache canceled."
fi
