import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

public class BunchFileConverter {

    public static void main(String[] args) {
        String inputFilePath = "packages_packages_dependencies.bunch"; // Giriş dosyasının yolu
        String outputFilePath = "java_modules_packages_dependencies_bunch_nahc.rsf"; // Çıktı dosyasının yolu
        convertFileFormat(inputFilePath, outputFilePath);
    }

    // Dosyadaki içeriği okuyarak formatı dönüştüren metot
    public static void convertFileFormat(String inputFilePath, String outputFilePath) {
        try (BufferedReader reader = new BufferedReader(new FileReader(inputFilePath));
             BufferedWriter writer = new BufferedWriter(new FileWriter(outputFilePath))) {

            String line;
            while ((line = reader.readLine()) != null) {
                // 'SS(...)' satırını bul ve işleme al
                if (line.startsWith("SS(")) {
                    // Regex ile doğru formatı yakala
                    String[] parts = line.split("=");
                    if (parts.length == 2) {
                        String source = parts[0].trim().replace("SS(", "").replace(")", "");
                        String targetsString = parts[1].trim();

                        // Hedefleri virgülle ayır
                        String[] targets = targetsString.split(",");

                        // Hedefleri istenilen formata dönüştür ve dosyaya yaz
                        for (String target : targets) {
                            writer.write("contain " + source + " " + target.trim());
                            writer.newLine();
                        }
                    }
                }
            }

            System.out.println("Dönüştürme işlemi tamamlandı. Sonuçlar " + outputFilePath + " dosyasına kaydedildi.");

        } catch (IOException e) {
            System.err.println("Dosya okuma/yazma hatası: " + e.getMessage());
        }
    }
}

