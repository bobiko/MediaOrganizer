#!/bin/bash

if [ -z "$1" ]; then
  echo "Podaj katalog do przetworzenia jako argument"
  exit 1
fi

cd "$1" || exit 2

path=$1

find "$path" -type f | grep -E "\.[a-zA-Z0-9]+$" | awk -F . '{print $NF}' | sort | uniq -c

echo "sum: $(find $path -type f | wc -l)"
echo "duplicated: $(find $path -type f -name "*_duplicate*" | wc -l)"
echo "subfolders: $(find $path -type d ! -path $1"/unsorted" | wc -l)"
echo "unsorted folders: $(find $path"/unsorted" -type d | wc -l)"
echo "subfolders max-depts: $(find $path -maxdepth 1 -type d | wc -l)"
