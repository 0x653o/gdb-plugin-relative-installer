#!/bin/sh
# Update the legacy (Python 3.6) GEF + Pwndbg install in the relative plugin folder.
# These stay pinned to Python 3.6-compatible refs; this re-asserts the pin after
# fetching. Bump the refs below (and re-run ./setup.sh) to move to a newer version.

BASE_DIR=$(dirname "$(readlink -f "$0")")
PLUGIN_DIR="$BASE_DIR/gdb-plugin"

GEF_REF="2021.10"
PWNDBG_REF="2023.07.17"

echo "[+] Updating legacy plugins in $PLUGIN_DIR"

update_pinned() {
    name=$1
    ref=$2
    target="$PLUGIN_DIR/$name"

    if [ -d "$target/.git" ]; then
        echo "[*] Updating $name (pinned to $ref)..."
        git -C "$target" fetch --tags --quiet
        git -C "$target" checkout --quiet "$ref"
    else
        echo "[!] $name not installed at $target — run ./setup.sh first."
    fi
}

update_pinned gef    "$GEF_REF"
update_pinned pwndbg "$PWNDBG_REF"

echo "[+] Legacy update complete."
