#!/bin/sh
# Completely removes everything installed by install.sh and setup.sh:
# cloned plugins, generated ~/.gdbinit profiles, and launcher commands.

BASE_DIR=$(dirname "$(readlink -f "$0")")
PLUGIN_DIR="$BASE_DIR/gdb-plugin"

echo "[+] Uninstalling GDB plugin environment..."

# 1. Launcher commands in /usr/local/bin (created by install.sh and setup.sh)
echo "[+] Removing launcher commands from /usr/local/bin..."
sudo rm -f /usr/local/bin/gdb-peda \
           /usr/local/bin/gdb-peda-arm \
           /usr/local/bin/gdb-peda-intel \
           /usr/local/bin/gdb-pwndbg \
           /usr/local/bin/gdb-gef

# 2. Generated gdbinit profiles (created by install.sh and setup.sh)
echo "[+] Removing ~/.gdbinit profiles..."
rm -f ~/.gdbinit ~/.gdbinit-gef ~/.gdbinit-pwndbg

# 3. Cloned plugins in the relative install directory (created by install.sh)
if [ -d "$PLUGIN_DIR" ]; then
    echo "[+] Removing cloned plugins at $PLUGIN_DIR..."
    rm -rf "$PLUGIN_DIR"
fi

# 4. Legacy GEF downloaded by setup.sh
if [ -d /opt/gef ]; then
    echo "[+] Removing /opt/gef (downloaded by setup.sh)..."
    sudo rm -rf /opt/gef
fi

echo "============================================================"
echo "[+] Uninstall complete."
echo "[*] Left untouched on purpose:"
echo "    - System packages (gdb, python3, git) and pip packages (six, setuptools)"
echo "    - /opt/pwndbg (not created by this project; remove it manually if you"
echo "      installed Pwndbg there for setup.sh)"
echo "============================================================"
