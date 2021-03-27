#!/bin/bash

# wget –c https://github.com/venice1200/MiSTer_tty2oled/releases/download/

echo -e "\ntty2oled update script"
echo "----------------------"

echo "Checking for available updates..."
tty2oled_gitver=$(wget -q https://raw.githubusercontent.com/ojaksch/MiSTer_tty2oled/master/Changelog.md -O - | awk '{print $2}')
[[ -f /media/fat/tty2oledpics/.version ]] && tty2oled_ver=$(cat /media/fat/tty2oledpics/.version)
[[ "${tty2oled_ver}" = "" ]] && tty2oled_ver="(none)"
echo "Local available version: ${tty2oled_ver} - Version at GitHub: ${tty2oled_gitver}"
if [ ${tty2oled_ver} = ${tty2oled_gitver} ]; then
  echo -e "No update available.\n"
  exit 1
fi

echo "Retrieving and processing update..."
wget -qO- https://github.com/ojaksch/MiSTer_tty2oled/releases/download/0.5/tty2oled-${tty2oled_gitver}.zip | bsdtar  -xf- --uname root --gname root -C /
[[ -f /etc/init.d/S60tty2oled ]] && chmod +x /etc/init.d/S60tty2oled
[[ -f /usr/bin/tty2oled ]] && chmod +x /usr/bin/tty2oled
echo "${tty2oled_gitver}" > /media/fat/tty2oledpics/.version

echo -e "Restarting init script\n"
/etc/init.d/S60tty2oled restart
