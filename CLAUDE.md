# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A set of POSIX `/bin/sh` scripts that install four GDB plugins — PEDA, PEDA-ARM/Intel, Pwndbg, and GEF — side by side and expose a separate launcher command for each. The distinguishing goal (vs. the upstream it forks, `apogiatzis/gdb-peda-pwndbg-gef`) is **relative-path installation**: plugins are cloned into a `gdb-plugin/` folder next to the installer rather than to hardcoded absolute paths, so the checkout can live anywhere.

There is no build, test, or lint tooling — the deliverables are the shell scripts themselves. Note the scripts are Linux/macOS-only (they call `apt`/`dnf`/`pacman`/`brew`, `sudo`, `/usr/local/bin`); they cannot run on the Windows host this repo may be edited from.

## Commands

```sh
./install.sh   # install deps, clone all four plugins into ./gdb-plugin, set up launchers
./update.sh    # git pull each plugin under ./gdb-plugin
```

After install, launch GDB with a plugin via the generated commands in `/usr/local/bin`:
`gdb-peda`, `gdb-peda-arm`, `gdb-peda-intel`, `gdb-pwndbg`, `gdb-gef` (e.g. `gdb-gef <binary>`). Per the README, `gdb-peda` is currently known not to work well.

## Architecture

The launch flow chains three pieces — understand all three before changing path handling:

1. **Wrapper scripts** (`gdb-peda`, `gdb-pwndbg`, etc.) are one-liners: `exec gdb -q -ex init-<plugin> "$@"`. They do **not** source plugin files directly; they only invoke an `init-*` command.
2. **`gdbinit`** (copied to `~/.gdbinit` by the installer) defines those `init-*` commands. At GDB startup it resolves the plugin location *dynamically* by running `find $HOME -type d -name "gdb-plugin" | head -n 1`, writing `$plugin_path` to a temp file, sourcing it, then deleting it. Each `init-*` command then `source`s the right plugin under `$plugin_path`. Consequence: the repo must live somewhere under `$HOME`, and if multiple `gdb-plugin` dirs exist the first match wins.
3. **`install.sh`** clones the plugins, runs Pwndbg's own `setup.sh` after cloning it, then installs `~/.gdbinit` and copies the wrappers to `/usr/local/bin`.

### Two path mechanisms coexist — one is vestigial

`install.sh` still contains `sed` patching (lines ~76, ~81-85) that rewrites a hardcoded `/home/g0d/...` path in `gdbinit` and rewrites `source ...` lines inside the wrapper scripts. **These no longer match anything**: the current `gdbinit` uses the runtime `find` instead of that hardcoded path, and the wrappers use `-ex init-*` instead of `source` lines. So the sed steps are effectively no-ops left over from the static-path approach. The live mechanism is the runtime `find` in `gdbinit`. Keep this in mind — editing the wrappers/gdbinit to match the sed patterns, or editing the sed to match the files, are two different design directions; don't half-apply one.

### `legacy/setup.sh` is a separate, divergent approach

`legacy/setup.sh` (documented in `legacy/README.md`) is **not** called by `install.sh` and follows a different model: it targets Ubuntu 18.04 / Python 3.6, pins a legacy GEF (`gef/2021.10`), uses absolute `/opt/gef` and `/opt/pwndbg` paths, handles only GEF + Pwndbg, and generates wrappers that load *separate* profile files (`~/.gdbinit-gef`, `~/.gdbinit-pwndbg`) via `gdb -x` while blanking `~/.gdbinit`. Treat it as an alternate/compatibility path, not part of the main relative-install flow.

### `uninstall.sh`

`uninstall.sh` removes the footprint of *both* installers: the launcher commands in `/usr/local/bin`, the generated `~/.gdbinit*` profiles, the relative `gdb-plugin/` clone dir, and the `/opt/gef` dir from `legacy/setup.sh`. It intentionally does **not** touch system/pip packages or `/opt/pwndbg` (which the project never creates).
