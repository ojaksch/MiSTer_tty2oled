#!/bin/bash

# v1.0 - Copyright (c) 2021 Oliver Jaksch, Lars Meuser

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# You can download the latest version of this script from:
# https://github.com/venice1200/MiSTer_tty2oled



# Changelog:
# v1.0	Main updater script which completes all tasks.



# REPOSITORY_URL="https://github.com/venice1200/MiSTer_tty2oled"
REPOSITORY_URL="https://github.com/ojaksch/MiSTer_tty2oled"
TTY2OLED_PATH="/media/fat/tty2oledpics"
NODEBUG="-q"

echo -e "\n\e[1;32mtty2oled update script"
echo -e "----------------------\e[0m"

echo -e "\e[1;32mChecking for available updates...\e[0m"
[ "${1}" = "-f" ] && echo -e "\e[1;31m-Forced update-\e[0m"

# init script
wget ${NODEBUG} "${REPOSITORY_URL}/blob/master/S60tty2oled?raw=true" -O /tmp/S60tty2oled
if ! cmp -s /tmp/S60tty2oled /etc/init.d/S60tty2oled || [ "${1}" = "-f" ]; then
  echo -e "\e[1;33mUpdating init script \e[1;35mS60tty2oled\e[0m"
  mv -f /tmp/S60tty2oled /etc/init.d/S60tty2oled
  chmod +x /etc/init.d/S60tty2oled
fi

# daemon
wget ${NODEBUG} "${REPOSITORY_URL}/blob/master/tty2oled?raw=true" -O /tmp/tty2oled
if ! cmp -s /tmp/tty2oled /usr/bin/tty2oled || [ "${1}" = "-f" ]; then
  echo -e "\e[1;33mUpdating daemon \e[1;35mtty2oled\e[0m"
  mv -f /tmp/tty2oled /usr/bin/tty2oled
  chmod +x /usr/bin/tty2oled
fi

# pictures
[[ -d /media/fat/tty2oledpics ]] || mkdir -m 777 /media/fat/tty2oledpics
wget ${NODEBUG} "${REPOSITORY_URL}/blob/master/translation_picture_core.md?raw=true" -O - | \
 grep ".xbm | " | cut -d " " -f 2 | \
 while read PICNAME; do
   if ! [ -f /media/fat/tty2oledpics/${PICNAME} ] || [ "${1}" = "-f" ]; then
     echo -e "\r\e[1;33mDownloading picture \e[1;35m${PICNAME}\e[0m"
     wget ${NODEBUG} "${REPOSITORY_URL}/blob/master/Pictures/XBM_SD/${PICNAME}?raw=true" -O /media/fat/tty2oledpics/${PICNAME}
   else
     echo -n "."
   fi
 done

echo -e "\e[1;32m(Re-) starting init script\n\e[0m"
/etc/init.d/S60tty2oled restart
