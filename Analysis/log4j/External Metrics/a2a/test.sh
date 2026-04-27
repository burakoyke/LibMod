#!/bin/bash

# Dosya isimleri ve sonuç etiketleri
files=("acdc_c.rsf" "mgmc_c.rsf" "bunch_nahc_c.rsf" "bunch_sahc_c.rsf" "ilp.rsf" "limbo_15_c.rsf" "limbo_20_c.rsf"  "limbo_25_c.rsf"  "limbo_30_c.rsf"  "limbo_35_c.rsf"  "limbo_40_c.rsf"  "limbo_45_c.rsf"  "limbo_50_c.rsf"  "limbo_55_c.rsf"  "limbo_60_c.rsf"  "fca_c.rsf")
labels=("ACDC Result" "MGMC Result" "Bunch-NAHC Result" "Bunch-SAHC Result" "Model V1 Result" "Limbo-15" "Limbo-20" "Limbo-25" "Limbo-30" "Limbo-35" "Limbo-40" "Limbo-45" "Limbo-50" "Limbo-55" "Limbo-60" "FCA")

# LC_NUMERIC'i ayarla (ondalık ayırıcı olarak nokta kullanılır)
export LC_NUMERIC="C"

# Döngüyle tüm dosyaları ve etiketleri işleyin
for i in "${!files[@]}"; do
    result=$(python3 a2a.py "${files[$i]}" modules_packages_dependencies.rsf)
    formatted_result=$(printf "%.2f" "$(echo "$result * 100" | bc -l)")
    echo "${labels[$i]}: $formatted_result"
done

