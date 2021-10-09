#!/bin/sh

# By venice & ojaksch

. /media/fat/tty2oled/tty2oled.ini

inotifywait -e modify "${corenamefile}"

# CURRENTPATH
# California Games.bin

# FULLPATH
# ATARI2600/NTSC/C

# STARTPATH
# Core gestartet: /media/fat/_Console/Atari2600_20210228.rbf
# sonst leer oder menu.rbf

# "/media/fat/$(cat /tmp/FULLPATH)/$(cat /tmp/CURRENTPATH)"
# [ -f "/media/fat/ATARI2600/NTSC/D/Dark Chambers.f6s" ] && echo yo
