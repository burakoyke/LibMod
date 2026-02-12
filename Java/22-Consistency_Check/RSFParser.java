import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.LinkedHashSet;

public class RSFParser {
    public static void main(String[] args) {
        // İlk dosyanın yolu
        String filePath1 = "packages_packages_dependencies.rsf";
        // İkinci dosyanın yolu
        String filePath2 = "modules_packages_dependencies.rsf";

        // 1. indeks için LinkedHashSet
        LinkedHashSet<String> index1Set = new LinkedHashSet<>();
        // 2. indeks için LinkedHashSet
        LinkedHashSet<String> index2Set = new LinkedHashSet<>();
        // modules_packages_dependencies.rsf için 2. indeks LinkedHashSet
        LinkedHashSet<String> moduleIndex2Set = new LinkedHashSet<>();

        // İlk dosya işleme
        try (BufferedReader br = new BufferedReader(new FileReader(filePath1))) {
            String line;
            while ((line = br.readLine()) != null) {
                // Satırı boşluk ile ayır
                String[] parts = line.split(" ");
                if (parts.length > 2) {
                    // 1. indeks LinkedHashSet'e eklenir
                    index1Set.add(parts[1]);
                    // 2. indeks LinkedHashSet'e eklenir
                    index2Set.add(parts[2]);
                }
            }
        } catch (IOException e) {
            System.err.println("Dosya okuma hatası (packages): " + e.getMessage());
        }

        // İkinci dosya işleme
        try (BufferedReader br = new BufferedReader(new FileReader(filePath2))) {
            String line;
            while ((line = br.readLine()) != null) {
                // Satırı boşluk ile ayır
                String[] parts = line.split(" ");
                if (parts.length > 2) {
                    // 2. indeks LinkedHashSet'e eklenir
                    moduleIndex2Set.add(parts[2]);
                }
            }
        } catch (IOException e) {
            System.err.println("Dosya okuma hatası (modules): " + e.getMessage());
        }

        // Listelerin boyutlarını yazdır
        System.out.println("packages 1. indeks LinkedHashSet boyutu: " + index1Set.size());
        System.out.println("packages 2. indeks LinkedHashSet boyutu: " + index2Set.size());
        System.out.println("modules 2. indeks LinkedHashSet boyutu: " + moduleIndex2Set.size());

        // Birbirinde olmayan elemanları yazdırma
        System.out.println("\n1. indeks setinde olup modules 2. indekste olmayanlar:");
        for (String element : index1Set) {
            if (!moduleIndex2Set.contains(element)) {
                System.out.println(element);
            }
        }

        System.out.println("\nmodules 2. indekste olup 1. indeks setinde olmayanlar:");
        for (String element : moduleIndex2Set) {
            if (!index1Set.contains(element)) {
                System.out.println(element);
            }
        }

        System.out.println("\npackages 2. indekste olup modules 2. indekste olmayanlar:");
        for (String element : index2Set) {
            if (!moduleIndex2Set.contains(element)) {
                System.out.println(element);
            }
        }

        System.out.println("\nmodules 2. indekste olup packages 2. indekste olmayanlar:");
        for (String element : moduleIndex2Set) {
            if (!index2Set.contains(element)) {
                System.out.println(element);
            }
        }
    }
}

