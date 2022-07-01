# Endophyte analysis using Qiime1
## Qiime
QIIME is an open-source bioinformatics pipeline for performing microbiome analysis from raw DNA sequencing data. 
QIIME is designed to take users from raw sequencing data generated on the Illumina or other platforms through publication quality graphics and statistics. 
This includes demultiplexing and quality filtering, OTU picking, taxonomic assignment, and phylogenetic reconstruction, and diversity analyses and visualizations.

## Docker Container Instalation
Our files have the 454 format, so if we want qiime to read them, we need the qiime1 version, a docker container allows us to use that version, you can find it in the [hohonuuli/qiime1 repository](https://github.com/hohonuuli/qiime1):
 
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
### Assign taxonomy to each sequence
We nee to use the `assign_taxonomy.py` script, it attempts to assign the taxonomy of each sequence given. Currently the methods implemented are assignment. In this case, in this case, we are going to use the uclust consensus taxonomy assigner (default):
```
assign_taxonomy.py -i seqs.fasta
```
### OTU picking
We have to assigns similar sequences to operational taxonomic units, or OTUs, by clustering sequences based on a user-defined similarity threshold. Sequences which are similar at or above the threshold level are taken to represent the presence of a taxonomic unit in the sequence collection. These actions can be executed with the `pick_otus.py` script.

Using the seqs.fna file and outputting the results to the directory `picked_otus/`:
```
pick_otus.py -i seqs.fasta -o picked_otus
```
### Make OTU table
The next step is to tabulate the number of times an OTU is found in each sample and add the taxonomic predictions for each OTU in the last column if a taxonomy file is provided. We are going to use the `make_otu_table.py` script.

From `pick_otus.py` results make the OTU table using an OTU file and a taxonomy assignment file:
```
make_otu_table.py -i seq_otus.txt -t seg_tax_assignment.txt -o otu_table.biom
```
### Plot heatmap of OTU table
Now we have to run `make_otu_heatmap.py`, it visualizes an OTU table as a heatmap where each row corresponds to an OTU and each column corresponds to a sample. The higher the relative abundance of an OTU in a sample, the more intense the color at the corresponsing position in the heatmap. By default, the OTUs (rows) will be clustered by UPGMA hierarchical clustering, and the samples (columns) will be presented in the order in which they appear in the OTU table. 

To visualizes an OTU table as a heatmap, use the following command:
```
make_otu_heatmap.py -i otu_table.biom -o heatmap.pdf
```
If we want to generate it as a PNG:
```
make_otu_heatmap.py -i otu_table.biom -o heatmap.png -g png
```
