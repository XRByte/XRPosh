#!/usr/bin/env bash

OMP_INSTALL_DIR="$HOME/.local/bin"
FONT_DIR="${ZDG_DATA_HOME:-$HOME/.local/share}/fonts"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}"

# Checks for directory and makes it if not present
check_dir() {
    [ ! -d "$1" ] && mkdir -p "$1"
}

check_dir "$OMP_INSTALL_DIR"

# Checks if curl is installed
if ! command -v curl >/dev/null 2>&1; then
    echo "Curl not installed. Please install curl and continue"
    exit 1
fi

# Install oh-my-posh
case "$1" in
*[Ll]inux*)
    if ! curl -s https://ohmyposh.dev/install.sh | bash -s -- -d "$OMP_INSTALL_DIR"; then
        exit 1
    fi
    ;;
*[Dd]arwin*)
    if ! brew install jandedobbeleer/oh-my-posh/oh-my-posh; then
        exit 1
    fi
    ;;
esac

# Check for nerdfont and install it
if ! command -v fc-list >/dev/null 2>&1; then
    echo "You need to install the fontconfig package and re run the script"
fi
if ! fc-list | grep -i nerd; then
    check_dir "$CACHE_DIR"
    check_dir "$FONT_DIR"

    if ! curl -L "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip" -o "$CACHE_DIR/nerdfont.zip"; then
        echo "Unable to download nerdfont. Please install a nerdfont manually and rerun the script"
        exit 1
    fi

    if command -v bsdtar >/dev/null 2>&1; then
        bsdtar -xf "$CACHE_DIR/nerdfont.zip" -C "$FONT_DIR"
    else
        python3 -m zipfile -e "$CACHE_DIR/nerdfont.zip" "$FONT_DIR"
    fi

    rm "$CACHE_DIR/nerdfont.zip"
    fc-cache -fv
fi

exit 0
