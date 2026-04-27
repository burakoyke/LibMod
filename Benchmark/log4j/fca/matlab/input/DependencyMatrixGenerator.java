import java.io.*;
import java.util.*;

public class DependencyMatrixGenerator {
    public static void main(String[] args) throws IOException {
        String inputFilePath = "packages_packages_dependencies.rsf";
        String outputFilePath = "dependency_matrix.txt";

        // Step 1: Parse the file and extract dependencies
        Map<String, Integer> packageIndexMap = new HashMap<>();
        List<String[]> dependencies = new ArrayList<>();
        
        try (BufferedReader reader = new BufferedReader(new FileReader(inputFilePath))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(" ");
                if (parts.length == 3 && parts[0].equalsIgnoreCase("depends")) {
                    String package1 = parts[1];
                    String package2 = parts[2];

                    dependencies.add(new String[]{package1, package2});

                    packageIndexMap.putIfAbsent(package1, packageIndexMap.size());
                    packageIndexMap.putIfAbsent(package2, packageIndexMap.size());
                }
            }
        }

        // Step 2: Check if the matrix will be square
        int size = packageIndexMap.size();
        Set<String> allPackages = new HashSet<>();
        for (String[] dependency : dependencies) {
            allPackages.add(dependency[0]);
            allPackages.add(dependency[1]);
        }

        if (allPackages.size() != size) {
            try (BufferedWriter logWriter = new BufferedWriter(new FileWriter("matrix_log.txt"))) {
                logWriter.write("Matrix is not square. The following packages are causing the issue:\n");

                for (String pkg : allPackages) {
                    if (!packageIndexMap.containsKey(pkg)) {
                        logWriter.write(pkg + " is missing in the index map.\n");
                    }
                }
            }

            System.out.println("Matrix is not square. See matrix_log.txt for details.");
            return;
        } else {
            System.out.println("Matrix is square. Proceeding with the generation of the matrix.");
        }

        // Step 3: Create adjacency matrix
        int[][] matrix = new int[size][size];

        for (String[] dependency : dependencies) {
            int index1 = packageIndexMap.get(dependency[0]);
            int index2 = packageIndexMap.get(dependency[1]);
            matrix[index1][index2] = 1;
        }

        // Step 4: Set diagonal elements to 0
        for (int i = 0; i < size; i++) {
            matrix[i][i] = 0;
        }

        // Step 5: Write matrix to file
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(outputFilePath))) {
            for (int i = 0; i < size; i++) {
                for (int j = 0; j < size; j++) {
                    writer.write(matrix[i][j] + "");
                    if (j < size - 1) {
                        writer.write(" ");
                    }
                }
                writer.write(";\n");
            }
        }

        System.out.println("Dependency matrix has been written to: " + outputFilePath);
    }
}

