# Module Level Dependency of Java 9

A Java utility that lists all modules in the Java 9 module system along with the packages they contain, and saves the output to a `.txt` file.

## How It Works

1. All registered Java modules are listed using the `java --list-modules` command.
2. For each module, the `java --describe-module <module-name>` command is executed.
3. Lines starting with `exports`, `qualified exports`, and `contains` are parsed to extract module-package relationships.
4. All relationships are written to a file named `module_package_dependencies.txt` in the following format:

```
contain <module-name> <package-name>
```

## Requirements

- **Java 9**  must be installed.

To verify your Java installation:

```bash
java -version
```

The output should show version `9`.

## Build & Run

### 1. Compile

```bash
javac --release 9 ModulePackageDependency.java
```

### 2. Run

```bash
java ModulePackageDependency
```

## Output

After the program runs, a file named `module_package_dependencies.txt` will be created in the same directory.

Example content:

```
contain java.base java.lang
contain java.base java.util
contain java.logging java.util.logging
...
```
