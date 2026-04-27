#!/bin/bash
# Usage: ./log4j_pack_class.sh <jar-file> [output-file]
# Generates package-class dependency list in format:
#   contain <package> <package>.<class>

set -e

if [ $# -lt 1 ]; then
  echo "Usage: $0 <jar-file> [output-file]" >&2
  exit 1
fi

JAR="$1"
OUT="${2:-package_class_dependencies.txt}"

if [ ! -f "$JAR" ]; then
  echo "Error: jar file not found: $JAR" >&2
  exit 1
fi

EXCLUDE_CLASSES=(
  "org.apache.log4j.spi.ErrorCode"
  "org.apache.log4j.lf5.viewer.LogTableModel"
  "org.apache.log4j.lf5.util.StreamUtils"
)

EXCLUDE_PATTERN=$(IFS='|'; echo "${EXCLUDE_CLASSES[*]}")

jar tf "$JAR" | grep '\.class$' | awk -F/ '{
  class_name = $NF
  sub(/\.class$/, "", class_name)
  pkg = ""
  for (i = 1; i < NF; i++) {
    pkg = (pkg == "" ? $i : pkg "." $i)
  }
  print "contain " pkg " " pkg "." class_name
}' | grep -vE " (${EXCLUDE_PATTERN})$" | sort -u > "$OUT"

echo "Wrote $(wc -l < "$OUT") lines to $OUT"
