#!/bin/bash
# Usage: ./log4j_class_class.sh <jar-file> [output-file]
# Generates class-class dependency list (log4j internal only) in format:
#   depends <fqn_class_1> <fqn_class_2>
# Adds dummy rows so both columns share the same unique class set (square matrix).

set -e

if [ $# -lt 1 ]; then
  echo "Usage: $0 <jar-file> [output-file]" >&2
  exit 1
fi

JAR="$1"
OUT="${2:-class_class_dependencies_log4j.txt}"

if [ ! -f "$JAR" ]; then
  echo "Error: jar file not found: $JAR" >&2
  exit 1
fi

# Göreli yolun temp dizine cd sonrası bozulmaması için absolute'a çevir
JAR=$(readlink -f "$JAR")
# Çıktı yolu da, temp'e cd yapacağımız için absolute olsun
case "$OUT" in
  /*) ;;
  *)  OUT="$PWD/$OUT" ;;
esac

if ! command -v javap >/dev/null 2>&1; then
  echo "Error: javap not found (install a JDK)" >&2
  exit 1
fi

INTERNAL_PREFIX="org.apache.log4j"

EXCLUDE_CLASSES=(
  "org.apache.log4j.spi.ErrorCode"
  "org.apache.log4j.lf5.viewer.LogTableModel"
  "org.apache.log4j.lf5.util.StreamUtils"
)
EXCLUDE_PATTERN=$(IFS='|'; echo "${EXCLUDE_CLASSES[*]}")

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

# 1) Jar'ı aç
( cd "$WORK" && jar xf "$JAR" )

RAW="$WORK/raw_deps.txt"
: > "$RAW"

# 2) Her class için referansları çıkar
find "$WORK" -name "*.class" | while read -r classfile; do
  rel="${classfile#$WORK/}"
  self="${rel%.class}"
  self="${self//\//.}"

  tmp=$(mktemp)
  javap -v "$classfile" 2>/dev/null > "$tmp"

  {
    # Constant pool Class entries
    grep -E "^[[:space:]]*#[0-9]+ = Class" "$tmp" | sed 's|.*// ||'
    # Descriptor L...; referansları (metot/alan imzaları, signature attributes)
    grep -oE 'L[a-zA-Z_][a-zA-Z0-9_/$]*;' "$tmp" | sed 's/^L//;s/;$//'
  } | sed 's|/|.|g' \
    | grep -v '^\[' \
    | sort -u \
    | grep -v "^${self}$" \
    | while read -r dep; do
        echo "$self $dep"
      done >> "$RAW"

  rm -f "$tmp"
done

# 3) Sadece log4j internal bağımlılıkları tut, exclude edilenleri çıkar,
#    "depends X Y" formatına çevir
awk -v pfx="$INTERNAL_PREFIX" '
  $1 ~ "^"pfx"(\\.|$)" && $2 ~ "^"pfx"(\\.|$)" { print "depends " $1 " " $2 }
' "$RAW" \
  | grep -vE " (${EXCLUDE_PATTERN})( |$)" \
  | grep -vE "^depends (${EXCLUDE_PATTERN}) " \
  | sort -u > "$OUT.core"

# 4) Kare matris için dummy satırları ekle
awk '{print $2}' "$OUT.core" | sort -u > "$WORK/col1.txt"
awk '{print $3}' "$OUT.core" | sort -u > "$WORK/col2.txt"

{
  cat "$OUT.core"
  # col1'de olup col2'de olmayanlar -> "depends dummy X"
  comm -23 "$WORK/col1.txt" "$WORK/col2.txt" | awk '{print "depends dummy " $1}'
  # col2'de olup col1'de olmayanlar -> "depends Y dummy"
  comm -13 "$WORK/col1.txt" "$WORK/col2.txt" | awk '{print "depends " $1 " dummy"}'
} | sort -u > "$OUT"

rm -f "$OUT.core"

# 5) Özet
total=$(wc -l < "$OUT")
c1=$(awk '{print $2}' "$OUT" | sort -u | wc -l)
c2=$(awk '{print $3}' "$OUT" | sort -u | wc -l)
echo "Wrote $total lines to $OUT"
echo "  unique class_name_1: $c1"
echo "  unique class_name_2: $c2"
