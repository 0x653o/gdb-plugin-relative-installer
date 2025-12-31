# 1. shell 명령을 사용하여 gdb-plugin 폴더를 찾고 경로를 변수에 저장합니다.
# find 명령어의 범위를 $HOME/Desktop으로 좁히면 검색 속도가 훨씬 빨라집니다.
shell PLUGIN_PATH=$(find $HOME -type d -name "gdb-plugin" | head -n 1); \
      echo "set \$plugin_path = \"$PLUGIN_PATH\"" > /tmp/gdb_path.gdb

# 2. 생성된 임시 경로 설정 파일을 불러옵니다.
source /tmp/gdb_path.gdb
shell rm /tmp/gdb_path.gdb

# --- 아래는 요청하신 명령어 정의 부분 (경로 변수 $plugin_path 활용) ---

define init-peda
  eval "source %s/peda/peda.py", $plugin_path
end
document init-peda
Initializes the PEDA (Python Exploit Development Assistant for GDB) framework
end

define init-peda-arm
  eval "source %s/peda-arm/peda-arm.py", $plugin_path
end
document init-peda-arm
Initializes the PEDA (Python Exploit Development Assistant for GDB) framework for ARM.
end

define init-peda-intel
  eval "source %s/peda-arm/peda-intel.py", $plugin_path
end
document init-peda-intel
Initializes the PEDA (Python Exploit Development Assistant for GDB) framework for INTEL.
end

define init-pwndbg
  eval "source %s/pwndbg/gdbinit.py", $plugin_path
end
document init-pwndbg
Initializes PwnDBG
end

define init-gef
  eval "source %s/gef/gef.py", $plugin_path
end
document init-gef
Initializes GEF (GDB Enhanced Features)
end

# 설치 확인 메시지
echo [+] Dynamic path initialization complete.\n