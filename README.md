# A Usage-Driven Optimization Approach to Software Library Modularization

This repository contains the dataset, scripts, and benchmarking tools used for the thesis **"A Usage-Driven Optimization Approach to Software Library Modularization"**. The project focuses on a novel optimization model for clustering software entities based on common usage patterns rather than direct dependencies, aimed at reducing redundant imports in software libraries.

## Authors
- **BURAK ÖYKE**, Vestel Electronics, Turkiye
- **OKAN ÖRSAN ÖZENER**, Ozyegin University, Turkiye
- **HASAN SÖZER**, Ozyegin University, Turkiye

---

## Project Overview

Traditional software modularization balances cohesion and coupling. However, for software libraries, cohesion should be defined by how frequently modules are used together. This research proposes an **Integer Linear Programming (ILP)** model to optimize library modularization using a multi-criteria optimization approach:

- **Mathematical Model 1 (MM1):** Aims to optimize the assignment of packages to clusters while minimizing the total number of packages imported as the objective function.
- **Mathematical Model 2 (MM2):** Aims to minimize the total number of clusters imported (NCI), while keeping the total number of packages imported (NUFI) below an upper bound determined by MM1.

The models address the trade-off between:
1. **NCI (Number of Clusters Imported):** The total number of clusters needed by all modules to satisfy their dependency requirements.
2. **NUFI (Number of Unnecessary Files Imported):** The total number of files/packages that are unnecessarily imported as part of a cluster.

The model is evaluated through two major case studies:
- **Android TV System:** An industrial library with 137 packages.
- **JDK 8 to 9 Transition:** Modularization of 865 packages into the Java Platform Module System (JPMS).

---

## Evaluation Metrics

The clustering results are evaluated using both internal and external metrics:

### Internal Metrics
- **NCI (Number of Clusters Imported):** Measures the compactness of the clustering.
- **NUFI (Number of Unnecessary Files Imported):** Measures the redundancy introduced by grouping.

### External Metrics (Similarity to Ground Truth)
- **MoJoFM:** A similarity metric based on move/join operations to transform one clustering into another.
- **a2a (Architecture-to-Architecture):** A distance-based measurement for architectural similarity.

---

## Repository Structure

The repository is organized into four main directories representing the experimental pipeline:

### 1. [Raw Dataset/](./Raw%20Dataset/)
Contains the original dependency data for the case studies.
- **Java 8 (Package-level):** Dependencies between packages in the monolithic JDK 8.
- **Java 9 (Module-level):** The ground truth modularization introduced in JPMS.

### 2. [Data Cleaning/](./Data%20Cleaning/)
A Java utility (`UpdateDependency.java`) to reconcile and clean package dependency files by cross-referencing module and package lists.
- **Input:** `modules_packages_dependencies.rsf`, `packages_packages_dependencies.rsf`.
- **Output:** Cleaned `.rsf` files used for benchmarking.

### 3. [Benchmark/](./Benchmark/)
Scripts and tools to execute various clustering algorithms for comparison:
- **Algorithms:** ACDC, Bunch (NAHC/SAHC), MGMC, ILP (Proposed Model), LIMBO, FCA.
- Each algorithm folder contains its respective JAR file, input data, and a `test.sh` script to run the clustering.

### 4. [Analysis/](./Analysis/)
Scripts to calculate performance metrics and compare results against ground truth.
- **External Metrics:** Python and shell scripts to calculate MoJoFM and a2a.
- **Internal Metrics:** Java tools (`PerformanceMeasuring.java`) to calculate NCI and NUFI for each algorithm's output.

---

## Getting Started

### Prerequisites
- Java 8 or higher (for data cleaning and benchmarking).
- Python 3.x (for external metric calculations).
- Bash shell (to run the test scripts).

### 1. Data Cleaning
Preprocess the raw dataset to ensure consistency:
```bash
cd "Data Cleaning"
javac UpdateDependency.java
java UpdateDependency
```

### 2. Running Benchmarks
Each clustering algorithm is located in its own subdirectory within the `Benchmark/` folder.

- **ACDC:** Uses an algorithm for comprehension-driven clustering.
  ```bash
  cd Benchmark/acdc
  ./testACDC.sh
  ```
- **Bunch (NAHC & SAHC):** Hill-climbing-based clustering. Requires running the JAR and then converting the output:
  ```bash
  cd Benchmark/bunch-nahc
  javac BunchFileConverter.java
  java BunchFileConverter
  ```
- **MGMC:** Multi-level Greedy Modularity Clustering.
  ```bash
  cd Benchmark/mgmc
  ./testClustering.sh
  ```
- **ILP (Proposed Model):** The results of the mathematical models (MM1 and MM2) discussed in the paper are available in `Benchmark/ilp/output`.
- **LIMBO:** Information-theoretic clustering.
  ```bash
  cd Benchmark/limbo/arcade
  java -jar arcade.jar -projfile cfg/Abdera.cfg
  ```
- **FCA:** Formal Concept Analysis. Clusters are resolved from a dependency matrix:
  ```bash
  cd Benchmark/fca
  javac ClusterDependencyResolver.java
  java ClusterDependencyResolver
  ```

### 3. Analyzing Results

#### Internal Metrics
Calculate **NCI (Number of Clusters Imported)** and **NUFI (Number of Unnecessary Files Imported)**:
```bash
cd "Analysis/Internal Metrics/acdc"
javac PerformanceMeasuring.java
java PerformanceMeasuring
```

#### External Metrics (Ground Truth Comparison)

- **a2a (Architecture-to-Architecture):** Measures architectural distance between clustering results and the ground truth.
  ```bash
  cd "Analysis/External Metrics/a2a"
  ./test.sh
  ```

- **MoJoFM:** Measures the similarity between clusterings based on move and join operations. Each algorithm's similarity can be calculated individually:
  ```bash
  cd "Analysis/External Metrics/MoJoFM/acdc"
  ./test.sh
  ```

---

