#!/bin/sh

# 1. 현재 경로 및 플러그인 경로 설정
installer_path=$(pwd)
plugin_path="$installer_path/gdb-plugin"

echo "[+] Target plugin directory: $plugin_path"
mkdir -p "$plugin_path"

# 종속성 라이브러리 설치 (PEDA 에러 방지용)
sudo apt update && sudo apt install -y python3-six python3-setuptools

# 플러그인 설치 함수 (기존 폴더 삭제 로직 포함)
install_plugin() {
    name=$1
    url=$2
    target="$plugin_path/$name"

    if [ -d "$target" ]; then
        echo "[-] $name found in $target"
        read -p "Existing $name detected. Overwrite and reinstall? (y/n): " choice
        if [ "$choice" = "y" ]; then
            echo "[+] Removing existing $name..."
            rm -rf "$target"
            echo "[+] Downloading $name..."
            git clone "$url" "$target"
            return 0 # Reinstalled
        else
            echo "[*] Skipping $name download."
            return 1 # Skipped
        fi
    else
        echo "[+] Downloading $name..."
        git clone "$url" "$target"
        return 0 # Newly installed
    fi
}

# 2. 각 플러그인 설치 진행
install_plugin "peda" "https://github.com/longld/peda.git"
install_plugin "peda-arm" "https://github.com/alset0326/peda-arm.git"

# Pwndbg는 설치 후 setup.sh 실행이 필요함
if install_plugin "pwndbg" "https://github.com/pwndbg/pwndbg.git"; then
    echo "[+] Running Pwndbg setup.sh..."
    cd "$plugin_path/pwndbg" && ./setup.sh
    cd "$installer_path"
fi

install_plugin "gef" "https://github.com/hugsy/gef.git"

# 3. gdbinit 경로 자동 수정 및 복사
echo "[+] Patching gdbinit with current path..."
# gdbinit 템플릿의 경로를 현재 실제 경로로 치환하여 ~/.gdbinit 생성
sed "s|/home/g0d/Desktop/files_etc/gdb-peda-pwndbg-gef/gdb-plugin|$plugin_path|g" gdbinit > ~/.gdbinit

# 4. 실행 스크립트(gdb-peda 등) 내부 경로 수정
echo "[+] Updating executable scripts..."
# 각 실행 파일이 gdb-plugin 폴더 내의 파일을 바라보도록 수정
sed -i "s|source .*|source $plugin_path/peda/peda.py\" \"\$@\"|g" gdb-peda
sed -i "s|source .*|source $plugin_path/peda-arm/peda-arm.py\" \"\$@\"|g" gdb-peda-arm
sed -i "s|source .*|source $plugin_path/peda-arm/peda-intel.py\" \"\$@\"|g" gdb-peda-intel
sed -i "s|source .*|source $plugin_path/pwndbg/gdbinit.py\" \"\$@\"|g" gdb-pwndbg
sed -i "s|source .*|source $plugin_path/gef/gef.py\" \"\$@\"|g" gdb-gef

# 5. 시스템 폴더로 복사 및 권한 부여
echo "[+] Copying executables to /usr/local/bin..."
sudo cp gdb-peda gdb-peda-arm gdb-peda-intel gdb-pwndbg gdb-gef /usr/local/bin/
sudo chmod +x /usr/local/bin/gdb-*

echo "[+] Installation complete at $installer_path"