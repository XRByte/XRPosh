#!/usr/bin/env bash

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#   ▀▄▀ █▀█ █▀█ █▀█ █▀ █░█
#   █░█ █▀▄ █▀▀ █▄█ ▄█ █▀█
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
#   This script provides a global function `xrposh` to manage shell
#   themes and colors.
#
#   Usage:
#     xrposh [OPTIONS]
#
#   Options:
#     -t, --theme THEME_NAME     Set the theme. Must be a theme in the
#                                $OMP_CONFIG_HOME/themes directory.
#     -c, --color COLOR_NAME     Set the color. Must be a color in the
#                                $OMP_CONFIG_HOME/colors directory.
#     -h, --help                 Show this help message and exit.
#
#   Example:
#     xrposh --theme sentinel --color tokyo-night
#
#   Environment:
#     OMP_CONFIG_HOME            Directory containing config, themes, colors
#                                and scripts. Defaults to the parent directory
#                                of the current working directory.
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

xrposh() {
    local OMP_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/oh-my-posh"
    local OMP_THEME_DIR="$OMP_CONFIG_HOME/themes"
    local OMP_COLOR_DIR="$OMP_CONFIG_HOME/colors"
    local OMP_SCRIPTS_DIR="$OMP_CONFIG_HOME/scripts"
    local OMP_COLOR=""
    local SET_COLOR="0"

    # Show help message
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        echo
        echo "  ▀▄▀ █▀█ █▀█ █▀█ █▀ █░█"
        echo "  █░█ █▀▄ █▀▀ █▄█ ▄█ █▀█"
        echo
        echo "  Usage:"
        echo "      xrposh [OPTIONS]"
        echo
        echo "  Options:"
        echo "      -t, --theme THEME_NAME     Set the theme. Must be a theme at"
        echo "                                 $OMP_CONFIG_HOME/themes."
        echo "      -c, --color COLOR_NAME     Set the color. Must be a color in the"
        echo "                                 $OMP_CONFIG_HOME/colors."
        echo "      -h, --help                 Show this help message and exit."
        echo
        echo "  Example:"
        echo "      xrposh --theme sentinel --color tokyo-night"

        return 0
    fi

    # Ensure config file exists
    if [[ ! -e "$OMP_CONFIG_HOME/config.omp.json" ]]; then
        if ! ln -s "$OMP_THEME_DIR/sentinel.json" "$OMP_CONFIG_HOME/config.omp.json" &>/dev/null; then
            echo "Fatal error. Unable to create symbolic link."
            return 1
        fi
    fi

    # Parse options
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
        --theme | -t)
            if [[ ! -f "$OMP_THEME_DIR/$2.json" ]]; then
                echo "Invalid theme name"
                return 1
            fi

            if [[ -e "$OMP_CONFIG_HOME/config.omp.json" ]]; then
                rm "$OMP_CONFIG_HOME/config.omp.json"
            fi

            if ! ln -s "$OMP_THEME_DIR/$2.json" "$OMP_CONFIG_HOME/config.omp.json" &>/dev/null; then
                echo "Fatal error. Unable to create symbolic link."
                return 1
            fi

            shift 2
            ;;

        --color | -c)
            if [[ ! -f "$OMP_COLOR_DIR/$2.json" ]]; then
                echo "invalid color name"
                return 1
            fi

            SET_COLOR="1"
            OMP_COLOR="$OMP_COLOR_DIR/$2.json"

            shift 2
            ;;

        *)
            echo "Invalid option"
            return 1
            ;;
        esac
    done

    # Apply color if specified
    if [[ "$SET_COLOR" -eq 1 ]]; then
        if ! command -v python3 &>/dev/null; then
            echo "python3 not found. Please install python3 and continue"
            return 1
        fi

        if ! python3 "$OMP_SCRIPTS_DIR/set_color.py" "$OMP_CONFIG_HOME/config.omp.json" "$OMP_COLOR"; then
            echo "Unable to set color"
            return 1
        fi
    fi
    return 0
}
