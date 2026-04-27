import java.io.*;
import java.util.*;

public class ClusterDependencyResolver {
    public static void main(String[] args) throws IOException {
        String inputFilePath = "c_in.rsf";
        String dependencyFilePath = "dependency_matrix_2.txt";
        String outputFilePath = "c_out.rsf";

        // Step 1: Read the dependency matrix and map IDs to package names
        Map<String, String> idToPackageMap = new HashMap<>();

        try (BufferedReader dependencyReader = new BufferedReader(new FileReader(dependencyFilePath))) {
            String line;
            while ((line = dependencyReader.readLine()) != null) {
                String[] parts = line.split(" "); // Split by spaces
                if (parts.length >= 2) {
                    String id = parts[0].trim();
                    String packageName = parts[1].trim();
                    idToPackageMap.put(id, packageName);
                }
            }
        }

        // Step 2: Process the input file and replace numbers with package names
        List<String> outputLines = new ArrayList<>();

        try (BufferedReader inputReader = new BufferedReader(new FileReader(inputFilePath))) {
            String line;
            while ((line = inputReader.readLine()) != null) {
                if (line.startsWith("contain Cluster")) {
                    String[] parts = line.trim().split(" ");
                    String clusterName = parts[1];

                    // Resolve each package and create a separate line for each
                    for (int i = 2; i < parts.length; i++) {
                        String id = parts[i].trim();
                        String packageName = idToPackageMap.getOrDefault(id, "UNKNOWN");
                        outputLines.add("contain " + clusterName + " " + packageName);
                    }
                } else if (!line.trim().isEmpty()) { // Ignore empty lines
                    outputLines.add(line); // Add non-empty lines that do not start with "contain Cluster" as-is
                }
            }
        }

        // Step 3: Write the resolved output to the file
        try (BufferedWriter outputWriter = new BufferedWriter(new FileWriter(outputFilePath))) {
            for (String resolvedLine : outputLines) {
                outputWriter.write(resolvedLine);
                outputWriter.newLine();
            }
        }

        System.out.println("Resolved clusters have been written to: " + outputFilePath);
    }
}

