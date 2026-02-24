#!/bin/bash

start=$(date +%s%3N)

java -jar clustering.jar output.txt c.txt
java -jar txt2rsf.jar c.txt java_modules_packages_dependencies_mgmc.rsf

end=$(date +%s%3N)

elapsed=$((end - start))

echo "Toplam çalışma süresi: ${elapsed} ms"
