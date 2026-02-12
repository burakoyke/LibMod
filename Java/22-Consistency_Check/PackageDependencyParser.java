import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.LinkedHashSet;

public class PackageDependencyParser {
    public static void main(String[] args) {

        String filePathPackages = "packages_packages_dependencies.rsf";
        String filePathModules = "modules_packages_dependencies.rsf";

        LinkedHashSet<String> package_1 = new LinkedHashSet<>();
        LinkedHashSet<String> package_2 = new LinkedHashSet<>();
        LinkedHashSet<String> module_1 = new LinkedHashSet<>();

        try (BufferedReader reader = new BufferedReader(new FileReader(filePathPackages))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(" ");
                if (parts.length > 2) {
                    package_1.add(parts[1]);
                    package_2.add(parts[2]);
                }
            }
        } catch (IOException e) {
            System.err.println("packages dosyası okunurken hata oluştu: " + e.getMessage());
        }

        try (BufferedReader reader = new BufferedReader(new FileReader(filePathModules))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(" ");
                if (parts.length > 2) {
                    module_1.add(parts[2]);
                }
            }
        } catch (IOException e) {
            System.err.println("modules dosyası okunurken hata oluştu: " + e.getMessage());
        }

        for (String packageElement : package_1) {
            if (!module_1.contains(packageElement)) {
                System.out.println("package_1 listesinde olup module_1 listesinde olmayan: " + packageElement);
            }
        }

        for (String packageElement : package_2) {
            if (!module_1.contains(packageElement)) {
                System.out.println("package_2 listesinde olup module_1 listesinde olmayan: " + packageElement);
            }
        }
    }
}
