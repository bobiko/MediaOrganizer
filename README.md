# MediaOrganizer

**MediaOrganizer**  to zestaw narzędzi - skryptów do uporządkowywania multimediów, ściągniętych z Google  Photos za [pomocą tej strony](https://takeout.google.com/). Analizuje informacje na podstawie metadanych (exif), nazwy plików czy daty i przenosi je do odpowiednich katalogów (zgodny z wzorcem `YYYY-MM`) z zachowaniem oryginalnych atrybutów plików, następnie pliki z pierwotnego katalogu.

## Problem

Przeglądając zawartość kopii zapasowych z Google Photos, można dostrzeć jeden wielki bałagan:

- albumy są w głownym katalogu;
- wszystkie zdjęcia są wrzucane do katagów, zgodnych z rocznikiem;
- dodatkowo zdjęcia są zduplikowane (te same znajdują sie zarówno w albumie jak i w rocznikowych katalogach);

## Cel

Główny:

- migracja z katalogów dostarczonych przez google,
- filtrowanie zdjęc wg.
  - daty z exif
  - data utworzenia plików z atrybutu plików
  - data na bazie nazwy plików
  - data na bazie timestamp, ukrytym w nazwie plików
- wrzucenie do odpowienich katalagów wg wzoraca "YYYY-MM".
  - w ostateczności dodaje do 'unsorted"
- w przypadku filmów z rozszerzeniem `mp4` `MP`
  - data utworzenia plików z atrybutu plików
  - sortowanie wg daty, ukrytej w nazwie plików

Dodatkowo:

- usuwa śmieci `.json`
- w przypadku powtorzenia sie zdjęcia i filmu o takiej samej nazwie
  - sprawdzić czy te pliki są takie same (pod wzgledem daty utworzenia i wagi pliku)
    - jeśli tak to dodać do końcówki nazwy `_duplicate`
    - jeśli nie to dodać kolejne cyferki typu 001
- przypadek rozszerzeń pisanych dużymi i małymi literami

## Wymagania systemowe

- dowolny UNIX'owe środowisko z`bash / zsh`
- pakiet `exiftool`


## Instalacja

1. Sklonuj repozytorium MediaOrganizer.
2. Zainstaluj ExifTool za pomocą polecenia sudo apt-get install exiftool w terminalu`

```bash
sudo apt install exiftool
git clone https://codeberg.org/bobiko/MediaOrganizer.git ./media-organizer
```

## Użycie

### `./media_organizer.sh`

```bash
./media_organizer.sh /dir/originals /dir/sorted
```

Dostepne opcje

- pierwszy parametr to ścieżka do katalogu z mediami;
- drugi parametr to ścieżka do katalogu z posortowanymi mediami
- `-v`- wyświetlanie potwierdzenia operacji przenoszenia kopiowania
- `-s`- wyświetlanie końcowych statystyk

### `./media_folder-cleanup.sh`

Skrypt sprawdza, czy nazwy utworzonych katalogów mieszczą się w przedziale lat: 2003 - 2023. Jeśli nie, to przenosi do katalogu `unsorted`

Dostepne opcje:

- pierwszy parametr to ścieżka do katalogu z mediami;
- drugi parametr to ścieżka do katalogu `unsorted`;

### `./media_summary.sh`

Skrypt wyświetla podsumowanie przenosznonych plików, podfolderów, duplikatów etc
Dostepne opcje:

- pierwszy parametr to ścieżka do katalogu, gdzie są wszystkie pliki;

## Uwagi

- Przed odpaleniem skryptów, należy zrobić kopię multimediów na wypadek przypadkowego usunięcia lub nadpisania plików.
- Jest spore prawdopobieństwo, ze nie wszystkie przypadki zostały uwzględnione, dlatego sklonuj / sforkuj  i dostosuj pod siebie
