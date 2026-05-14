
# gdb-plugin-relative-installer

THIS REPO IS INSPIRED BY 
https://github.com/apogiatzis/gdb-peda-pwndbg-gef
AND THIS REPO IS FOR RELATIVE PATH INSTALLATION

---
# Pwndbg + GEF + Peda - One for all, and all for one

This is a script which installs Pwndbg, GEF, and Peda GDB plugins in a single command.

Run `install.sh` and then use one of the commands below to launch the corresponding GDB environment:

```
gdb-peda - not work well(when bug is fixed, then do update.sh)
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

# Installation

The installer automatically detects your package manager and installs necessary dependencies (`gdb`, `python3`, `pip`, `git`) and Python libraries (`six`, `setuptools`).

```
git clone https://github.com/yourusername/gdb-plugin-relative-installer.git
cd gdb-plugin-relative-installer
./install.sh
```

## Update

```
./update.sh
```