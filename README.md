# Sublime Text 3 Configurations

Centralized repository for Sublime Text 3 snippets, settings, and customizations.

## Quick Start

```bash
git clone <repo-url> sublime-text-configurations
cd sublime-text-configurations
./scripts/setup-config.sh              # Configure paths
./scripts/install-python-snippets.sh   # Install snippets
```

Restart Sublime Text, then type `pyhelp` + Tab in any Python file to see all snippets.

## Configuration

`.sublime-config` stores machine-specific paths (git-ignored).

**Platform paths:**
- macOS: `~/Library/Application Support/Sublime Text 3/Packages/User`
- Linux: `~/.config/sublime-text-3/Packages/User`
- Windows: `%APPDATA%\Sublime Text 3\Packages\User`

## Python Snippets (24 total)

- **Core:** `main`, `cls`, `def`
- **Error Handling:** `try`, `tryf`
- **API/Data:** `req`, `env`, `withopen`
- **Testing:** `test`, `fixture`
- **Logging:** `log`, `logi`
- **Algorithms:** `chunk`, `flatten`, `counter`, `groupby`
- **Boilerplates:** `boiler`, `cliboiler`, `initpy`
- **Advanced:** `context`, `decorator`, `dectimer`
- **Debug:** `pdb`
- **Help:** `pyhelp`

## Scripts

**setup-config.sh** - Auto-detects OS and configures `.sublime-config`

**install-python-snippets.sh** - Copies snippets to Sublime User directory

## Multi-Machine Workflow

**New machine:**
```bash
./scripts/setup-config.sh
./scripts/install-python-snippets.sh
```

**After editing snippets:**
```bash
./scripts/install-python-snippets.sh
git add . && git commit -m "Update snippets" && git push
```

**Pull updates:**
```bash
git pull
./scripts/install-python-snippets.sh
```

## Adding Snippets

1. Create `.sublime-snippet` file in `snippets/python/`
2. Add to `py-help.sublime-snippet` reference
3. Run `./scripts/install-python-snippets.sh`
