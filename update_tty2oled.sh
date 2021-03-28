#!/bin/bash

# Copyright (c) 2021 Oliver Jaksch

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



SCRIPTNAME="/tmp/update_script_tty2oled.sh.sh"

echo -e "\nIf you want to FORCE an update, please re-run with parameter -f"

wget -q https://raw.githubusercontent.com/ojaksch/MiSTer_tty2oled/master/update_script.sh -O ${SCRIPTNAME}
case  ${?} in
    0) bash ${SCRIPTNAME} ${1} ;;
    1) echo "wget: Generic error code." ;;
    2) echo "wget: Parse error---for instance, when parsing command-line options, the .wgetrc or .netrc..." ;;
    3) echo "wget: File I/O error." ;;
    4) echo "wget: Network failure." ;;
    5) echo "wget: SSL verification failure." ;;
    6) echo "wget: Username/password authentication failure." ;;
    7) echo "wget: Protocol errors." ;;
    8) echo "wget: Server issued an error response." ;;
    *) echo "Unexpected and uncatched error." ;;
esac

[[ -f ${SCRIPTNAME} ]] && rm ${SCRIPTNAME}

exit 0
