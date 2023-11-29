#!/bin/bash
if [ $# -lt 2 ]; then
  echo "Błąd: należy podać co najmniej dwa parametry: katalog źródłowy i katalog docelowy"
  exit 1
fi

if [ ! -d "$1" ]; then
  echo "Błąd: katalog źródłowy $1 nie istnieje lub nie jest katalogiem"
  exit 2
fi

if [ ! -d "$2" ]; then
  echo "Błąd: katalog docelowy $2 nie istnieje lub nie jest katalogiem"
  exit 3
fi


COLLECTIVE_DIR="$2"
UNSORTED_DIR="$COLLECTIVE_DIR/unsorted"
FILE_COUNT=0
DIR_COUNT=0
TOTAL_SIZE=0
START_TIME=$(date +%s)

# Sprawdź, czy podano flagę -v lub -s
VERBOSE=false
STATS=false
if [ $# -gt 2 ]; then
  for arg in "${@:3}"; do
    if [ "$arg" == "-v" ]; then
      VERBOSE=true
    elif [ "$arg" == "-s" ]; then
      STATS=true
    else
      echo "Błąd: nieznana flaga $arg"
      exit 4
    fi
  done
fi


find "$1" -type f | while read FILE; do
  FILENAME=$(basename "$FILE")
  EXTENSION=${FILENAME##*.}

  EXTENSION=${EXTENSION,,}
  if [[ "$EXTENSION" =~ ^(jpg|jpeg|png|gif|mp4|mp|dng)$ ]]; then
    DATE=$(stat -c %y "$FILE" | cut -d'-' -f1,2)
    EXIF_DATE=$(exiftool -d "%Y-%m" -DateTimeOriginal "$FILE" 2>/dev/null | cut -d':' -f2 | tr -d ' ')
    if [ -n "$EXIF_DATE" ] && [ "$EXIF_DATE" != "$DATE" ]; then
      DATE="$EXIF_DATE"
    elif [[ "$EXTENSION" =~ ^(mp4|mp)$ ]]; then
      REGEX="([0-9]{4})([0-9]{2})([0-9]{2})"
      if [[ "$FILENAME" =~ $REGEX ]]; then
        YEAR=${BASH_REMATCH[1]}
        MONTH=${BASH_REMATCH[2]}
        DAY=${BASH_REMATCH[3]}
        DATE="$YEAR-$MONTH"
      fi
    elif [[ "$EXTENSION" =~ ^(jpg|jpeg|png|gif|dng)$ ]] && [ -z "$EXIF_DATE" ] && [ "$DATE" == "$(date +%Y-%m)" ]; then
      REGEX="([0-9]{4})([0-9]{2})([0-9]{2})"
      if [[ "$FILENAME" =~ $REGEX ]]; then
        YEAR=${BASH_REMATCH[1]}
        MONTH=${BASH_REMATCH[2]}
        DAY=${BASH_REMATCH[3]}
        DATE="$YEAR-$MONTH"
      else
        REGEX="([0-9]{10})([0-9]{3})?"
        if [[ "$FILENAME" =~ $REGEX ]]; then
          TIMESTAMP=${BASH_REMATCH[1]}
          DATE=$(date -d @$TIMESTAMP +%Y-%m)
        else
          DATE="unsorted"
        fi
      fi
    fi
    TARGET_DIR="$COLLECTIVE_DIR/$DATE"

    if [ ! -d "$TARGET_DIR" ]; then
      mkdir -p "$TARGET_DIR"
      DIR_COUNT=$((DIR_COUNT + 1))
    fi

    if [ -f "$TARGET_DIR/$FILENAME" ]; then
      SOURCE_DATE=$(stat -c %y "$FILE")
      TARGET_DATE=$(stat -c %y "$TARGET_DIR/$FILENAME")
      SOURCE_SIZE=$(stat -c %s "$FILE")
      TARGET_SIZE=$(stat -c %s "$TARGET_DIR/$FILENAME")
      if [ "$SOURCE_DATE" == "$TARGET_DATE" ] && [ $SOURCE_SIZE -eq $TARGET_SIZE ]; then
        FILENAME="${FILENAME%.*}_duplicate.$EXTENSION"
      else
        NUM=1
        while [ -f "$TARGET_DIR/${FILENAME%.*}_$NUM.$EXTENSION" ]; do
          NUM=$((NUM + 1))
        done
        FILENAME="${FILENAME%.*}_$NUM.$EXTENSION"
      fi
    fi
    cp -p "$FILE" "$TARGET_DIR/$FILENAME"
    rm "$FILE"
    FILE_COUNT=$((FILE_COUNT + 1))
    TOTAL_SIZE=$((TOTAL_SIZE + SOURCE_SIZE))
    if [ "$VERBOSE" == "true" ]; then
      echo "✅ $FILE do $TARGET_DIR/$FILENAME"
    fi
  fi
done

END_TIME=$(date +%s)

ELAPSED_TIME=$((END_TIME - START_TIME))

if [ "$STATS" == "true" ]; then
  echo "Liczba przeniesionych plików: $FILE_COUNT"
  echo "Liczba utworzonych katalogów: $DIR_COUNT"
  echo "Całkowity rozmiar przeniesionych plików: $TOTAL_SIZE bajtów"
  echo "Czas wykonania skryptu: $ELAPSED_TIME sekund"
fi
