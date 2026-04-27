#!/bin/bash

start=$(date +%s%3N)

java -jar acdc.jar class_class_dependencies.rsf output/log4j_packages_class_dependencies_acdc.rsf

end=$(date +%s%3N)

elapsed=$((end - start))

echo "Toplam çalışma süresi: ${elapsed} ms"

