#!/bin/bash

start=$(date +%s%3N)

java -jar Run.jar

end=$(date +%s%3N)

elapsed=$((end - start))

echo "Toplam çalışma süresi: ${elapsed} ms"

