#!/bin/bash

# Ordner ./dist löschen und neu erstellen
rm -rf ./dist
mkdir ./dist
mkdir ./dist/ABs
mkdir ./dist/HTML

# Vorher-Pfad speichern
START_PWD=$(pwd)

# Funktion um .tex Dateien zu verarbeiten
process_tex_files() {
  local dir="$1"
  for tex_file in "$dir"/*.tex; do
    if [[ -e "$tex_file" ]]; then
      local parent_dir
      parent_dir=$(basename "$(dirname "$dir")")
      cd "$dir"
      for tf in ./*.tex; do
        pdflatex -shell-escape -halt-on-error "$tf" | grep '^!.*' -A200 --color=always
        cp "${tf%.tex}.pdf" "$START_PWD/dist/ABs/${parent_dir}.pdf"
      done
      cd "$START_PWD"
    fi
  done
}
# Ordner ./ABs und Unterordner nach .tex Dateien durchsuchen
find ./ABs -type d -name 'AB' | while read -r subdir; do
  process_tex_files "$subdir"
done

# HTML Dateien kopieren
find ./ABs/*/*.html -exec cp {} "./dist/HTML" \;