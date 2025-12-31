#!/bin/sh
BASE_DIR=$(dirname "$(readlink -f "$0")")
PLUGIN_DIR="$BASE_DIR/gdb-plugin"

echo "[+] Updating plugins in $PLUGIN_DIR"

for plugin in peda peda-arm pwndbg gef; do
    if [ -d "$PLUGIN_DIR/$plugin" ]; then
        echo "[*] Updating $plugin..."
        cd "$PLUGIN_DIR/$plugin" && git pull
    fi
done

cd "$BASE_DIR"
echo "[+] All updates completed."