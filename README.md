# Endophyte analysis using Qiime1
## Qiime
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
docker run --name qiime1 -v $(pwd):/mnt/data -i -t mbari/qiime1 /bin/bash
```
Once inside the container use the following command:

```
source activate qiime1
```
### Other commands
Docker command to list the running containers:
```
docker ps -a
```
Command to atart/stop a container:
```
docker container stop <<container_id>>
docker container start <<container_id>>
```
Command to delete all containers:
```
docker rm $(docker ps -a -q)
```
## Using Qiime1
### Otu picking
[OTU picking](http://qiime.org/scripts/pick_otus.html) assigns similar sequences to operational taxonomic units, or OTUs, by clustering sequences based on a user-defined similarity threshold. Sequences which are similar at or above the threshold level are taken to represent the presence of a taxonomic unit in the sequence collection.

Using the seqs.fna file and outputting the results to the directory “picked_otus/”:
```
pick_otus.py -i seqs.fna -o picked_otus_default
```
