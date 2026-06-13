#!/bin/sh
# Completely removes the legacy (Python 3.6) install created by ./setup.sh:
# the relative plugin folder, the generated ~/.gdbinit profiles, and the launchers.

BASE_DIR=$(dirname "$(readlink -f "$0")")
PLUGIN_DIR="$BASE_DIR/gdb-plugin"

echo "[+] Uninstalling legacy GDB plugin environment..."

# 1. Launcher commands
echo "[+] Removing /usr/local/bin/gdb-gef and gdb-pwndbg..."
sudo rm -f /usr/local/bin/gdb-gef /usr/local/bin/gdb-pwndbg

# 2. Generated gdbinit profiles
echo "[+] Removing ~/.gdbinit-gef and ~/.gdbinit-pwndbg..."
rm -f ~/.gdbinit-gef ~/.gdbinit-pwndbg

# 3. Relative plugin install (cloned GEF + Pwndbg)
if [ -d "$PLUGIN_DIR" ]; then
    echo "[+] Removing $PLUGIN_DIR..."
    rm -rf "$PLUGIN_DIR"
fi

echo "============================================================"
echo "[+] Legacy uninstall complete."
echo "[*] System packages and the Python deps installed by pwndbg/setup.sh"
echo "    were left in place."
echo "============================================================"
