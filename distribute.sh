#!/bin/bash

# Ordner ./dist löschen und neu erstellen
rm -rf ./dist
mkdir ./dist
mkdir ./dist/ABs
mkdir ./dist/HTML

# Funktion um .tex Dateien zu verarbeiten
process_tex_files() {
  local dir="$1"
  for tex_file in "$dir"/*.tex; do
    if [[ -f "$tex_file" ]]; then
      local parent_dir
      parent_dir=$(basename "$(dirname "$dir")")
      pdflatex -shell-escape -output-directory "$dir" -halt-on-error "$tex_file" | grep '^!.*' -A200 --color=always 
      pdf_file="${tex_file%.tex}.pdf"
      if [[ -f "$pdf_file" ]]; then
        mv "$pdf_file" "./dist/ABs/${parent_dir}.pdf"
      fi
    fi
  done
}

# Ordner ./ABs und Unterordner nach .tex Dateien durchsuchen
find ./ABs -type d -name 'AB' | while read -r subdir; do
  process_tex_files "$subdir"
done

# Minted temporäre Ordner löschen
rm -r _minted*