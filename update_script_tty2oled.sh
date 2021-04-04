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
tty2oled_gitver=$(wget ${NODEBUG} "${REPOSITORY_URL}/blob/master/version?raw=true" -O - | cut -f 2)
[[ -f ${TTY2OLED_PATH}/.version ]] && tty2oled_ver=$(<${TTY2OLED_PATH}/.version)
[[ "${tty2oled_ver}" = "" ]] && tty2oled_ver="(none)"
echo -e "\e[1;32mLocal available version: ${tty2oled_ver} - Version at GitHub: ${tty2oled_gitver}\e[0m"
if [ ${tty2oled_ver} = ${tty2oled_gitver} ]; then
    echo -ne "\e[1;33mNo update available"
    if [ "${1}" = "-f" ]; then
	echo -e ", but update forced.\n\e[0m"
    else
	echo -e ".\n\e[0m"
	exit 1
    fi
fi

echo -e "\e[1;32mRetrieving and processing update...\e[0m"
mkdir -p /media/fat/tty2oledpics
wget ${NODEBUG} -O- "${REPOSITORY_URL}/releases/download/${tty2oled_gitver}/tty2oled-${tty2oled_gitver}.zip" | bsdtar  -xf- --uname root --gname root -C /
[[ -f /etc/init.d/S60tty2oled ]] && chmod +x /etc/init.d/S60tty2oled
[[ -f /usr/bin/tty2oled ]] && chmod +x /usr/bin/tty2oled
echo "${tty2oled_gitver}" > ${TTY2OLED_PATH}/.version

echo -e "\e[1;32m(Re-) starting init script\n\e[0m"
/etc/init.d/S60tty2oled restart
