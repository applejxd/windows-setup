#!/bin/bash

# shellcheck source=/dev/null
source ../.venv/bin/activate

sphinx-apidoc -e -f -M -o ./sphinx ../src
rm -rf ./build/html/img
cp -r ../img ./build/html/img
rm -rf ./build/latex/img 
cp -r ./img ./build/latex/img

make html
make latexpdf
