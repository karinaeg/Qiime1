# Qiime1
QIIME is an open-source bioinformatics pipeline for performing microbiome analysis from raw DNA sequencing data. 
QIIME is designed to take users from raw sequencing data generated on the Illumina or other platforms through publication quality graphics and statistics. 
This includes demultiplexing and quality filtering, OTU picking, taxonomic assignment, and phylogenetic reconstruction, and diversity analyses and visualizations.

## Docker Container Instalation
Our files have the 454 format, so if we want qiime to read them, we need the qiime1 version, a docker container allows us to use that version, you can find it in the following link: https://github.com/hohonuuli/qiime1
 
To start an interactive session, first start a bash shell into the container:

```
docker pull mbari/qiime1
```
Your data will be in /mnt/data, the command in the shared repository has an error on `/bash/bin`, this is the correct syntax:

```
docker run --name qiime1 -v /Path/to/data:/mnt/data -i -t mbari/qiime1 /bin/bash
```
Once inside the container use the following command:

```
source activate qiime1
```
