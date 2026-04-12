# SwiftBar Plugins

A collection of [SwiftBar](https://github.com/swiftbar/SwiftBar) plugins for macOS menu bar utilities.

---

## Plugins

### `exchange-rates.5m.sh` — Currency Exchange Rates

Displays live USD→BRL and GBP→BRL exchange rates in the menu bar, refreshed every 5 minutes.

**What it does:**
- Shows a compact `🇧🇷 $X.XX · £X.XX` summary in the menu bar
- Dropdown shows full 4-decimal rates for both currency pairs
- Pulls data from [frankfurter.dev](https://frankfurter.dev) (free, no API key required)
- Displays the data date and a manual refresh option

**Dependencies:**
- `curl` — available by default on macOS
- `python3` — available by default on macOS (or via Homebrew)

No additional setup required.

---

### `audio-switch.1h.sh` — Audio Device Switcher

Shows the active audio output device in the menu bar. Click to switch input or output devices without opening System Settings.

**What it does:**
- Displays the current output device name (truncated to 20 chars if needed)
- Dropdown lists all available output and input devices
- Active device is marked with a checkmark (✓) in green
- Clicking any device switches to it immediately and refreshes the plugin

**Dependencies:**
- [`switchaudio-osx`](https://github.com/deweller/switchaudio-osx) — install via Homebrew:

```bash
brew install switchaudio-osx
```

If `SwitchAudioSource` is not found, the plugin shows a friendly error with installation instructions.

---

## Installation

### 1. Install SwiftBar

Download from [swiftbar.app](https://swiftbar.app) or via Homebrew:

```bash
brew install --cask swiftbar
```

### 2. Set a plugin directory

On first launch, SwiftBar will ask you to choose a plugin directory. Pick or create a folder, e.g. `~/SwiftBarPlugins/`.

### 3. Clone this repo and link (or copy) the plugins

```bash
git clone git@github.com:helsky-labs/swiftbar-plugins.git ~/swiftbar-plugins

# Option A: symlink (plugins auto-update when you pull)
ln -s ~/swiftbar-plugins/exchange-rates.5m.sh ~/SwiftBarPlugins/
ln -s ~/swiftbar-plugins/audio-switch.1h.sh ~/SwiftBarPlugins/

# Option B: copy
cp ~/swiftbar-plugins/exchange-rates.5m.sh ~/SwiftBarPlugins/
cp ~/swiftbar-plugins/audio-switch.1h.sh ~/SwiftBarPlugins/
```

### 4. Install plugin dependencies

```bash
# For audio-switch only
brew install switchaudio-osx
```

### 5. Refresh SwiftBar

Right-click any SwiftBar item → **Refresh All** — or relaunch SwiftBar.

---

## Adding New Plugins

1. Write your plugin script following the [SwiftBar plugin API](https://github.com/swiftbar/SwiftBar#plugin-api).
2. Name the file with a refresh interval in the filename: `plugin-name.5m.sh`, `plugin-name.1h.sh`, `plugin-name.1d.sh`, etc.
3. Make it executable: `chmod +x your-plugin.Xm.sh`
4. Drop it in your SwiftBar plugins directory (or symlink it).
5. Add it to this repo and document it in this README.

**Filename interval format:** `<name>.<number><unit>.sh`
- Units: `s` (seconds), `m` (minutes), `h` (hours), `d` (days)
- Example: `my-plugin.30s.sh` refreshes every 30 seconds

---

## License

MIT
