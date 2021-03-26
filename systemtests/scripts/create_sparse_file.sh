#!/bin/sh
#   BAREOS® - Backup Archiving REcovery Open Sourced
#
#   Copyright (C) 2016-2021 Bareos GmbH & Co. KG
#
#   This program is Free Software; you can redistribute it and/or
#   modify it under the terms of version three of the GNU Affero General Public
#   License as published by the Free Software Foundation and included
#   in the file LICENSE.
#
#   This program is distributed in the hope that it will be useful, but
#   WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
#   Affero General Public License for more details.
#
#   You should have received a copy of the GNU Affero General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
#   02110-1301, USA.

verbose=""
if [ "${1:-}" = "-v" ]; then
   verbose="yes"
   shift
fi

filename=${1:-sparse.dat}
size=${2:-100M}

echo "start" > $filename
dd if=/dev/zero of=$filename bs=1 count=0 seek=$size 2>/dev/null
echo "end" >> $filename

size="$(du -B 1 --apparent-size ${filename} | cut -f 1)"
realsize="$(du -B 1 ${filename} | cut -f 1)"

if [ "$verbose" ]; then
   printf "$filename created.\n"
   printf "size=%s\n" "$size"
   printf "realsize=%s\n" "$realsize"
fi

if [ "$realsize" -gt "$size" ]; then
    printf "ERROR: realsize has to be smaller than size.\n"
    exit 1
fi
