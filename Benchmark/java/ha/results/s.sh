#!/bin/bash

INPUT_JSON="$1"
OUTPUT_FILE="output.rsf"

if [ -z "$INPUT_JSON" ]; then
  echo "Kullanım: $0 input.json"
  exit 1
fi

> "$OUTPUT_FILE"

jq -r 'to_entries[] | "\(.key)\t\(.value[0])"' "$INPUT_JSON" |
while IFS=$'\t' read -r key value; do

  # Module number extraction
  mod_num=$(echo "$key" | sed -E 's/[^0-9]*([0-9]+).*/\1/')

  # split tab-separated classes
  echo "$value" | tr '\t' '\n' | while read -r cls; do

    # cleanup
    cls=$(echo "$cls" | sed 's/"//g' | sed 's/\\//g')

    # skip empty / dummy
    if [ -z "$cls" ] || [ "$cls" = "dummy" ]; then
      continue
    fi

    # final format
    echo "contain Module_${mod_num} $cls" >> "$OUTPUT_FILE"

  done
done

echo "Bitti: $OUTPUT_FILE oluşturuldu."
