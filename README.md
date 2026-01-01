
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

# Installation

```
git clone 
cd ~/gdb-peda-pwndbg-gef
./install.sh
```

## Update

```
./update.sh
```