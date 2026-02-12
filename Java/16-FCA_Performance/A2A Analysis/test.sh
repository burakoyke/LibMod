#!/bin/bash

# Dosya isimleri ve sonuç etiketleri
files=("acdc_c.rsf" "mgmc_c.rsf" "bunch_c.rsf" "model_v1_c.rsf" "fca_c.rsf")
labels=("ACDC Result" "MGMC Result" "Bunch Result" "Model V1 Result" "FCA")

# LC_NUMERIC'i ayarla (ondalık ayırıcı olarak nokta kullanılır)
export LC_NUMERIC="C"

# Döngüyle tüm dosyaları ve etiketleri işleyin
for i in "${!files[@]}"; do
    result=$(python3 a2a.py "${files[$i]}" modules_packages_dependencies.rsf)
    formatted_result=$(printf "%.2f" "$(echo "$result * 100" | bc -l)")
    echo "${labels[$i]}: $formatted_result"
done

