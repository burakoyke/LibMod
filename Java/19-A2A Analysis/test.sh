#!/bin/bash

# Dosya isimleri ve sonuç etiketleri
files=("acdc_c.rsf" "mgmc_c.rsf" "bunch_nahc_c.rsf" "bunch_sahc_c.rsf" "model_v1_c.rsf" "model_v2_c.rsf" "model_v3_c.rsf" "limbo_50_c.rsf" "limbo_75_c.rsf" "limbo_100_c.rsf" "limbo_150_c.rsf" "limbo_200_c.rsf" "limbo_250_c.rsf" "limbo_500_c.rsf")
labels=("ACDC Result" "MGMC Result" "Bunch-NAHC Result" "Bunch-SAHC Result" "Model V1 Result" "Model V2 Result" "Model V3 Result" "Limbo-50" "Limbo-75" "Limbo-100" "Limbo-150" "Limbo-200" "Limbo-250" "Limbo-500")

# LC_NUMERIC'i ayarla (ondalık ayırıcı olarak nokta kullanılır)
export LC_NUMERIC="C"

# Döngüyle tüm dosyaları ve etiketleri işleyin
for i in "${!files[@]}"; do
    result=$(python3 a2a.py "${files[$i]}" modules_packages_dependencies.rsf)
    formatted_result=$(printf "%.2f" "$(echo "$result * 100" | bc -l)")
    echo "${labels[$i]}: $formatted_result"
done

