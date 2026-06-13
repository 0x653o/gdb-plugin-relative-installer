# Legacy install for older GDB (Ubuntu 18.04 / GDB < 9.1)

A self-contained installer for environments with an **older GDB and Python**, where the
latest GEF/Pwndbg releases will not load — for example **Ubuntu 18.04** (GDB 8.1.x,
Python 3.6). On a modern system, use the repo-root [`install.sh`](../README.md) instead.

Everything here installs into a **relative** folder (`legacy/gdb-plugin/`) — no `/opt`.

## Install

```
./setup.sh
```

This clones two plugins into `legacy/gdb-plugin/`, pinned to Python 3.6-compatible refs:

| Plugin | Ref | Notes |
| --- | --- | --- |
| GEF    | `2021.10`    | last GEF release supporting Python 3.6 |
| Pwndbg | `2023.07.17` | last Pwndbg release supporting Python 3.6 / Ubuntu 18.04 |

It then runs `pwndbg/setup.sh` to install Pwndbg's Python dependencies, writes the
`~/.gdbinit-gef` and `~/.gdbinit-pwndbg` profiles (each sourcing the relative install),
and installs the `gdb-gef` / `gdb-pwndbg` launcher commands into `/usr/local/bin`.

Launch with:

```
gdb-gef <binary>
gdb-pwndbg <binary>
```

## Update

```
./update.sh
```

Fetches and re-pins GEF and Pwndbg to the refs above. To move to a different version,
edit the `*_REF` variables in `setup.sh` / `update.sh` and re-run `./setup.sh`.

## Uninstall

```
./uninstall.sh
```

Removes `legacy/gdb-plugin/`, the `~/.gdbinit-gef` / `~/.gdbinit-pwndbg` profiles, and the
`gdb-gef` / `gdb-pwndbg` commands from `/usr/local/bin`. System packages and the Python
deps installed by `pwndbg/setup.sh` are left in place.

## Notes

- Covers **GEF and Pwndbg only** — no PEDA in this legacy path.
- The refs are pinned for Python 3.6; bumping them may break on Ubuntu 18.04.
- Verified on **Ubuntu 18.04.6 LTS** — GDB 8.1.1, Python 3.6.9, git 2.17.1.
