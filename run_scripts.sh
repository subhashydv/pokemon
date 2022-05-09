#! /bin/bash
source scripts/generate_website.sh

TARGET_DIR="html"
POKEMON_TEMPLATE="resources/templates/pokemon_template.html"
CARD_TEMPLATE="resources/templates/card_template.html"
DATA_FILE="resources/data/pokemon.csv"

rm -r $TARGET_DIR/* 2> /dev/null
mkdir -p $TARGET_DIR
cp -r resources/images resources/styles.css $TARGET_DIR/

generate_website "$DATA_FILE" "$TARGET_DIR" "$POKEMON_TEMPLATE" "$CARD_TEMPLATE"

open $TARGET_DIR/all.html