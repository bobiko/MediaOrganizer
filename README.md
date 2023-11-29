# MediaOrganizer

**MediaOrganizer**  to narzędzie do uporządkowywania zdjęć i filmów na podstawie metadanych, exif, nazwy plików czy daty utworzenia plików do oddzielnych katalogów wg wzorca `YYYY-MM`.
Narzędzie to umożliwia łatwe i szybkie sortowanie plików multimedialnych, co pozwala na łatwiejsze zarządzanie kolekcją zdjęć i filmów.

## Cel

## Wymagania systemowe
- Linux lub macOS
- Środowisko Bash
- pakiet `ExifTool`
-
`
## Instalacja

1. Sklonuj repozytorium MediaOrganizer.
2. Zainstaluj ExifTool za pomocą polecenia sudo apt-get install exiftool w terminalu`
3.
```bash
sudo apt install exiftool
git clone git@codeberg.org:bobiko/MediaOrganizer.git ./media-organizer
```

## Użycie

### `Media_organizer`

```bash
./media_organizer.sh /dir/originals /dir/sorted
```

dostpępne opcje

- `-v`- wyświetlanie wszystkich informacji
- `-s` - statystyka

### `media_cleanup`

## Uwaga
Pamiętaj, aby zawsze posiadać kopię oryginalnych zdjęć i filmów na wypadek przypadkowego usunięcia lub nadpisania plików.

## Licencja
Ten projekt jest udostępniany na licencji MIT. Szczegóły znajdują się w pliku LICENSE.
