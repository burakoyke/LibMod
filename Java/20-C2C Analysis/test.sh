#!/bin/bash

# Dosya isimleri ve sonuç etiketleri
files=("acdc_c.rsf" "mgmc_c.rsf" "bunch_nahc_c.rsf" "bunch_sahc_c.rsf" "model_v1_c.rsf" "limbo_50_c.rsf" "limbo_75_c.rsf" "limbo_100_c.rsf" "limbo_150_c.rsf" "limbo_200_c.rsf" "limbo_250_c.rsf" "limbo_500_c.rsf")
labels=("ACDC Result" "MGMC Result" "Bunch-NAHC Result" "Bunch-SAHC Result" "Model V1 Result" "Limbo-50" "Limbo-75" "Limbo-100" "Limbo-150" "Limbo-200" "Limbo-250" "Limbo-500")

# LC_NUMERIC'i ayarla (ondalık ayırıcı olarak nokta kullanılır)
export LC_NUMERIC="C"

# Döngüyle tüm dosyaları ve etiketleri işleyin
for i in "${!files[@]}"; do
    echo "${labels[$i]}:"
    
    # Python scriptinden sonuçları al
    result=$(python3 c2c.py modules_packages_dependencies.rsf "${files[$i]}")

    # Sonuçları ayrıştır ve hizalanmış şekilde yazdır
    echo "$result" | awk '
    {
        if (NR % 2 == 1) {
            category = $0;
        } else {
            value = $0;
            printf "  %-10s: %.2f\n", category, value;
        }
    }'
    echo # Boş bir satır ekle
done

