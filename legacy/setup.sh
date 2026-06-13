#!/bin/sh
# Legacy GDB plugin setup for older environments (Ubuntu 18.04, GDB 8.1.x, Python 3.6).
# Installs Python 3.6-compatible GEF + Pwndbg into a RELATIVE folder next to this
# script (no /opt), and points the launcher commands at that folder.

# Resolve this script's own directory and use a relative plugin folder.
BASE_DIR=$(dirname "$(readlink -f "$0")")
PLUGIN_DIR="$BASE_DIR/gdb-plugin"

# Refs pinned for Python 3.6 / Ubuntu 18.04. Edit these if your toolchain differs.
GEF_REF="2021.10"         # last GEF release supporting Python 3.6
PWNDBG_REF="2023.07.17"   # last Pwndbg release supporting Python 3.6 / Ubuntu 18.04

echo "[+] Legacy setup -> $PLUGIN_DIR"
mkdir -p "$PLUGIN_DIR"

# Clone (or refresh) a repo and pin it to a specific ref.
clone_pinned() {
    name=$1
    url=$2
    ref=$3
    target="$PLUGIN_DIR/$name"

    if [ -d "$target/.git" ]; then
        echo "[*] $name already present; fetching..."
        git -C "$target" fetch --tags --quiet
    else
        echo "[+] Cloning $name..."
        rm -rf "$target"
        git clone --quiet "$url" "$target"
    fi
    echo "[+] Pinning $name to $ref"
    git -C "$target" checkout --quiet "$ref"
}

# 1. GEF (single-file plugin, no build step needed)
clone_pinned gef    https://github.com/hugsy/gef.git    "$GEF_REF"

# 2. Pwndbg (run its own setup.sh to install Python dependencies)
clone_pinned pwndbg https://github.com/pwndbg/pwndbg.git "$PWNDBG_REF"
echo "[+] Installing Pwndbg dependencies (pwndbg/setup.sh)..."
( cd "$PLUGIN_DIR/pwndbg" && ./setup.sh )

# 3. Separate ~/.gdbinit profiles pointing at the relative install
echo "[+] Writing ~/.gdbinit-gef and ~/.gdbinit-pwndbg profiles..."
echo "source $PLUGIN_DIR/gef/gef.py"        > ~/.gdbinit-gef
echo "source $PLUGIN_DIR/pwndbg/gdbinit.py" > ~/.gdbinit-pwndbg

# 4. Launcher wrappers in /usr/local/bin (load only one profile at a time)
echo "[+] Installing launcher commands in /usr/local/bin..."
cat << 'EOF' | sudo tee /usr/local/bin/gdb-gef >/dev/null
#!/bin/sh
exec gdb -q -x ~/.gdbinit-gef "$@"
EOF
cat << 'EOF' | sudo tee /usr/local/bin/gdb-pwndbg >/dev/null
#!/bin/sh
exec gdb -q -x ~/.gdbinit-pwndbg "$@"
EOF
sudo chmod +x /usr/local/bin/gdb-gef /usr/local/bin/gdb-pwndbg

echo "============================================================"
echo "[+] Legacy setup complete. Plugins installed in $PLUGIN_DIR"
echo "[*] Use 'gdb-gef <binary>'    to launch with GEF."
echo "[*] Use 'gdb-pwndbg <binary>' to launch with Pwndbg."
echo "============================================================"
