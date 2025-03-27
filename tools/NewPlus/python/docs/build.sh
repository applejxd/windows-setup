#!/bin/bash

source ./.venv/bin/activate

sphinx-apidoc -e -f -o ./sphinx -M ./src

sphinx-build -a ./sphinx ./docs
sphinx-build -b latex ./sphinx ./docs/latex

rm -rf ./docs/img
cp -r ./img ./docs/img
rm-rf ./docs/latex/img
cp -r ./img ./docs/latex/img

make -C ./docs/latex all-pdf

cd docs/latex
MAIN_TEX=$(find . -maxdepth 1 -name "*.tex" | head -n 1)
MAIN_TEX=$(basename "$MAIN_TEX")
lualatex "$MAIN_TEX"
lualatex "$MAIN_TEX"
cd ../../
