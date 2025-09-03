
# XRPosh - Oh My Posh Theme & Color Manager

XRPosh is a lightweight command-line utility to **manage [Oh My Posh](https://ohmyposh.dev/) themes and colors dynamically** and **add custom themes and colors** using JSON configuration files.


## Requirements

- *Python 3* (for color application)
- [*Oh My Posh*](https://ohmyposh.dev/docs/installation/linux) installed
- A [Nerd Font](https://www.nerdfonts.com/) installed

---

## Installation

```bash
git clone https://github.com/XRByte/xrposh.git
cd xrposh
<shell> install.sh
```
`<shell>` refers to the shell where you want to install XRPosh. For example:
If you are using zsh, run install.sh using
```bash
zsh install.sh
```
Similarly, if you want to install in bash, run install..sh using
```bash
bash install.sh
```
> **Note:** At the end of the installation, you would be prompted to copy a few lines to your shell configuration file and restart/source your shell for the changes to take effect.

### Supported platforms

|MacOS|Linux|
|-----|-----|

### Supported shells
Any ***POSIX*** compliant shell
|Bash|Zsh|Dash|Ash|Ksh|
|----|---|----|---|---|

---

## Usage

Once sourced, the `xrposh` command becomes available globally:

```bash
xrposh [OPTIONS]
```

### Options

| Option              | Description |
|---------------------|-------------|
| -t, --theme *THEME* | Set the theme. Must match a JSON file in the `themes` folder. |
| -c, --color *COLOR* | Set the color. Must match a JSON file in the `colors` folder. |
| -h, --help          | Display this help message. |

### Examples

#### Set a theme
```bash
xrposh --theme sentinel
```

#### Set a theme
```bash
xrposh --color blue
```

#### Set both color and theme
```bash
xrposh --theme sentinel --color tokyo-night
```

---

## Configuration

XRPosh uses a configuration directory at `$XDG_CONFIG_HOME/oh-my-posh`. If `$XDG_CONFIG_HOME` is unset, it points to `$HOME/.config/oh-my-posh`. In case the directory already exists, the installer creates a time-stamped backup of the old directory at the same location with the name `oh-my-posh.bak.<timestamp>`.

The oh-my-posh directory structure is as follows:

```bash
$OMP_CONFIG_HOME/
├── themes/         # Theme JSON files
├── colors/         # Color JSON files
├── scripts/        # Internal scripts (like set_color.py)
└── config.omp.json # Symlink to the currently active theme
```

> **Note:** The theme and color names must match the JSON file names in their respective folders (without the `.json` extension). Adding new themes or colors is as simple as placing the JSON file in the appropriate folder.

---

## Adding Custom Themes or Colors

The `JSON` files defined in the **colors** directory follow a color palette. The `JSON` files follow a few simple rules:

- The color names in the palette must be consistent in both the theme and color file.
- Themes must have a palette defined in them
- The theme segment colors must be defined from this palette for the theme to remain dynamic

To add a custom theme/color:

1. Add a JSON file to `themes/` with a unique name, e.g., `themes/maximal.json`
2. Add a JSON file to `colors/` with a unique name, e.g., `colors/neutral.json`
3. Use the name (without `.json`) with `--theme` or `--color`.

```bash
xrposh --theme maximal --color neutral
```

> **Note:** I am not very creative with names, so I have come up with segment-type specific names. I plan to switch to neutral names and extend the color palette in future updates.

---

## Roadmap

Future updates will focus on the following features
- [ ] Oh my posh installation script if not installed
- [ ] Platform agnostic and shell agnostic
- [ ] Neutral color names
- [ ] Extend color palette to support more colors
- [ ] Add more color options
- [ ] Add more theme options

---

## Contributing

Contributions are welcome for completing the simple roadmap or adding new features.  If you want to contribute. please ensure:

- Installation must not break system or remove any preexisting files
- Add comments and clear documentation for new features or functions.
- Test your changes locally before opening a pull request.
- Do not commit secrets, credentials, or system-specific paths.
- Follow the existing project structure
---

## Support

If you encounter issues, please open a GitHub issue.
