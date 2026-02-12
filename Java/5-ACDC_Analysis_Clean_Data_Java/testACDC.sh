#!/bin/bash

start=$(date +%s%3N)

java -jar acdc.jar packages_packages_dependencies.rsf java_modules_packages_dependencies_acdc.rsf

end=$(date +%s%3N)

elapsed=$((end - start))

echo "Toplam çalışma süresi: ${elapsed} ms"

