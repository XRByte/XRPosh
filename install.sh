#!/usr/bin/env bash

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#   ▀▄▀ █▀█ █▀█ █▀█ █▀ █░█
#   █░█ █▀▄ █▀▀ █▄█ ▄█ █▀█
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#   This script copies themes, colors, and scripts to your config
#   directory, sets up Oh-My-Posh, and makes the xrposh function
#   available for changing themes and colors easily.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Set default config locations
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
OMP_CONFIG_HOME="${XDG_CONFIG_HOME}/oh-my-posh"

# Detect the shell currently running this script (bash, zsh, etc.)
CURRENT_SHELL=$(ps -p $$ -o comm= | sed 's/^-//')

# Get the directory where this script lives
SCRIPT_PATH="$(dirname "$0")"
SCRIPTS_DIR="${SCRIPT_PATH}/scripts"
COLORS_DIR="${SCRIPT_PATH}/colors"
THEMES_DIR="${SCRIPT_PATH}/themes"
SCHEMA_FILE="${SCRIPT_PATH}/schema.json"
INSTALLER_DIR="${SCRIPT_PATH}/install/omp_install"
OS="$(uname)"

# List of items to copy to the config directory
files=("$SCRIPTS_DIR" "$COLORS_DIR" "$THEMES_DIR" "$SCHEMA_FILE")

# Make sure oh-my-posh is installed
if ! command -v oh-my-posh &>/dev/null; then
    case "$OS" in
    *[Ll]inux* | *[Dd]arwin*)
        if ! bash "$INSTALLER_DIR/unix.sh" "$OS"; then
            echo "Unable to install oh-my-posh. Please install it manually and rerun the script"
        fi
        ;;
    *)
        echo "XRPosh cannot be installed on $OS"
        ;;
    esac
fi

# Create the oh-my-posh config folder if it doesn't exist
if [[ -d "$OMP_CONFIG_HOME" ]]; then
    mv "$OMP_CONFIG_HOME" "$OMP_CONFIG_HOME.bak.$(date +%Y%m%d%H%M%S)"
fi

if ! mkdir -p "$OMP_CONFIG_HOME" &>/dev/null; then
    echo "Unable to create $OMP_CONFIG_HOME"
    exit 1
fi

# Copy all the necessary files to the config folder
for item in "${files[@]}"; do
    if ! cp -r "$item" "$OMP_CONFIG_HOME" &>/dev/null; then
        echo "Unable to copy $item to $OMP_CONFIG_HOME"
        exit 1
    fi
done

# Source our set_theme script and call xrposh to apply defaults
source "$OMP_CONFIG_HOME/scripts/set_theme.sh"

# Initialize Oh-My-Posh for the current shell
xrposh
eval "$(oh-my-posh init "$CURRENT_SHELL" --config "$OMP_CONFIG_HOME/config.omp.json")" >/dev/null

# Friendly message for the user with manual steps
cat <<EOF
You need to add the following lines to your shell configuration file:

    eval "\$(oh-my-posh init $CURRENT_SHELL --config '$OMP_CONFIG_HOME/config.omp.json')"
    source "$OMP_CONFIG_HOME/scripts/set_theme.sh"

For example:
  - Bash: add the above lines to $HOME/.bashrc
  - Zsh: add the above lines to $HOME/.zshrc

Then restart your shell using:

    exec $CURRENT_SHELL

EOF

exit 0
