#!/bin/bash

if [ -z "$1" ]; then
  echo "Podaj katalog do przetworzenia jako argument"
  exit 1
fi

cd "$1" || exit 2


if [ ! -d unsorted ]; then
  mkdir unsorted
fi

for dir in *; do
  if [ "$dir" = "unsorted" ]; then
    continue
  fi

  if [[ "$dir" =~ ^[0-9]{4}-[0-9]{2}$ ]]; then
    year=${dir:0:4}
    month=${dir:5:2}
    if [ "$year" -ge 2003 ] && [ "$year" -le 2023 ] && [ "$month" -ge 1 ] && [ "$month" -le 12 ]; then
      continue
    fi
  fi
  mv "$dir" unsorted
done
