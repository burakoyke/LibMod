# Cleaning Data

A Java utility that cleans and reconciles package dependency files by cross-referencing module and package dependency lists.

## Overview

This tool reads two dependency files, filters out invalid or unresolvable entries, and produces updated output files that are consistent with each other.

## Input Files

| File | Description |
|------|-------------|
| `input/modules_packages_dependencies.rsf` | Maps modules to their packages |
| `input/packages_packages_dependencies.rsf` | Defines dependencies between packages |

Each file follows a space-separated format: `<type> <element1> <element2>`

## Output Files

| File | Description |
|------|-------------|
| `packages_packages_dependencies_new.rsf` | Cleaned package-to-package dependencies |
| `modules_packages_dependencies_new.rsf` | Filtered module dependencies, excluding unused modules |

## How It Works

1. **Reads** the modules file and extracts the list of known packages.
2. **Validates** each entry in the packages file against the known package list.
3. **Adjusts** unrecognized package names by trimming trailing characters until a match is found, or marks them as `dummy` if no match exists.
4. **Removes** any entries containing `dummy` values.
5. **Filters** the modules file to remove modules that no longer appear in the updated packages list.
6. **Saves** the results to the output files.

## Usage

Compile and run with standard Java tools:

```bash
javac UpdateDependency.java
java UpdateDependency
```

> Make sure the `input/` directory exists and contains the required `.rsf` files before running.

## Requirements

- Java 8 or higher
- No external dependencies
