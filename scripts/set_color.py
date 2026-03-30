"""

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

▀▄▀ █▀█ █▀█ █▀█ █▀ █░█
█░█ █▀▄ █▀▀ █▄█ ▄█ █▀█

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

set_color.py - Apply a color scheme to a theme JSON file.

This script takes a theme JSON file and a color JSON file, then updates
the "palette" section of the theme with the colors provided in the color file.

The modified theme JSON is written back to the original theme file.

Usage:
    python3 set_color.py THEME_FILE COLOR_FILE

Positional Arguments:
    THEME_FILE   Path to the theme JSON file to update.
    COLOR_FILE   Path to the color JSON file to apply.

Behavior:
    1. Checks that both input files exist. If not, exits with an error.
    2. Loads the JSON data from the color file and theme file.
    3. Updates the "palette" dictionary in the theme with the colors.
    4. Overwrites the original theme file with the updated JSON.

Example:
    python3 set_color.py ~/config/themes/dark.json ~/config/colors/blue.json

Notes:
    - The script assumes that the theme JSON has a top-level key "palette"
    which is a dictionary.
    - The color JSON should have a top-level key "colors" which is a dictionary.
    - The script overwrites the theme file in-place.
"""

import json
import os
import sys


def check_file(path):
    """
    Check if the given file exists.

    Args:
        path (str): Path to the file to check.

    Raises:
        SystemExit: If the file does not exist.
    """
    if not os.path.exists(path):
        sys.stdout.write(f"No file named {path}\n")
        sys.exit(1)


if __name__ == "__main__":
    # Read command line arguments
    theme_file, color_file = os.path.abspath(sys.argv[1]), sys.argv[2]

    # Validate files
    check_file(theme_file)
    check_file(color_file)

    # Open both files and update the theme palette
    with open(color_file, "r") as cf, open(theme_file, "r+") as tf:
        colors = json.load(cf)
        theme = json.load(tf)

        # Update theme palette with colors
        theme.get("palette").update(colors.get("colors"))

        # Write updated theme back to file
        tf.seek(0)
        tf.truncate()
        json.dump(theme, tf, indent=4)
