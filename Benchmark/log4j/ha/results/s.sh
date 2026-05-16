python3 << 'EOF' > log4j_package_class_dependencies_HA.rsf
import json
import re

with open("input.json", "r") as f:
    data = json.load(f)

for row in data:
    module = "Module 1"

    # FIELD'ları topla
    for k, v in row.items():
        if k.startswith("FIELD") and isinstance(v, str):
            v = v.strip()

            # Module switch (FIELD içinde Module 207 vs olabilir)
            if re.match(r"Module \d+", v):
                module = v
                continue

            # gerçek Java class
            if "org.apache" in v:
                print(f"contain {module} {v}")

    # Solution fallback (bozuk JSON string içinden class çek)
    sol = str(row.get("Solution", ""))

    for m in re.findall(r'org\.apache\.[A-Za-z0-9_.$]+', sol):
        print(f"contain {module} {m}")
EOF
