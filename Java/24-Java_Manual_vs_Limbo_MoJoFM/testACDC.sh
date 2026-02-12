#!/bin/bash


java -jar mojo.jar Abdera_LIMBO_preselected_ilm_50_clusters.rsf java_modules_packages_dependencies_cleaned.rsf -fm
java -jar mojo.jar Abdera_LIMBO_preselected_ilm_75_clusters.rsf java_modules_packages_dependencies_cleaned.rsf -fm
java -jar mojo.jar Abdera_LIMBO_preselected_ilm_100_clusters.rsf java_modules_packages_dependencies_cleaned.rsf -fm
java -jar mojo.jar Abdera_LIMBO_preselected_ilm_150_clusters.rsf java_modules_packages_dependencies_cleaned.rsf -fm
java -jar mojo.jar Abdera_LIMBO_preselected_ilm_200_clusters.rsf java_modules_packages_dependencies_cleaned.rsf -fm
java -jar mojo.jar Abdera_LIMBO_preselected_ilm_250_clusters.rsf java_modules_packages_dependencies_cleaned.rsf -fm
java -jar mojo.jar Abdera_LIMBO_preselected_ilm_500_clusters.rsf java_modules_packages_dependencies_cleaned.rsf -fm

