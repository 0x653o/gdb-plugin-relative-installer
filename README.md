
# gdb-plugin-relative-installer

THIS REPO IS INSPIRED BY 
https://github.com/apogiatzis/gdb-peda-pwndbg-gef
AND THIS REPO IS FOR RELATIVE PATH INSTALLATION

---
# Pwndbg + GEF + Peda - One for all, and all for one

This is a script which installs Pwndbg, GEF, and Peda GDB plugins in a single command.

Run `install.sh` and then use one of the commands below to launch the corresponding GDB environment:

```
gdb-peda
gdb-peda-intel
gdb-peda-arm
gdb-pwndbg
gdb-gef
```

For more information read the relevant blog post:

https://medium.com/bugbountywriteup/pwndbg-gef-peda-one-for-all-and-all-for-one-714d71bf36b8

# Requirements

- **OS**: Linux (Ubuntu, Fedora, Arch, etc.) or macOS
- **GDB**: 9.1 or higher
- **Python**: 3.8 or higher
- **Package Manager**: apt, dnf, pacman, or Homebrew
- **Git**

# Test Enviroment

- **OS**: Ubuntu 22.04 or higher

> **Older GDB / Python (e.g. Ubuntu 18.04)?** If your GDB is below 9.1, `install.sh` may fail to load the latest GEF/Pwndbg. Use the legacy installer in [`legacy/`](legacy/README.md) instead.

# Installation

The installer automatically detects your package manager and installs necessary dependencies (`gdb`, `python3`, `pip`, `git`) and Python libraries (`six`, `setuptools`. `uv`).

```
git clone https://github.com/yourusername/gdb-plugin-relative-installer.git
cd gdb-plugin-relative-installer
./install.sh
```

## Legacy install for older GDB

Running an older GDB/Python (e.g. **Ubuntu 18.04**, GDB 8.1.x, Python 3.6)? The standard `install.sh` won't load the latest GEF/Pwndbg. Use the dedicated legacy installer instead:

➡️ **[`legacy/`](legacy/README.md)** — a Python 3.6-compatible GEF + Pwndbg setup (`legacy/setup.sh`).

## Update

```
./update.sh
```

## Uninstall

To completely remove the installed plugins, generated `~/.gdbinit` profiles, and launcher commands:

```
./uninstall.sh
```

This deletes the cloned `gdb-plugin/` directory, the `gdb-peda*` / `gdb-pwndbg` / `gdb-gef` commands in `/usr/local/bin`, the generated `~/.gdbinit`, `~/.gdbinit-gef`, and `~/.gdbinit-pwndbg` files, and the `/opt/gef` directory created by `legacy/setup.sh`. System packages (`gdb`, `python3`, `git`) and `/opt/pwndbg` are left untouched.
