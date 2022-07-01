# Endophyte analysis using Qiime1
## What is Qiime?
QIIME is an open-source bioinformatics pipeline for performing microbiome analysis from raw DNA sequencing data. 
QIIME is designed to take users from raw sequencing data generated on the Illumina or other platforms through publication quality graphics and statistics. 
This includes demultiplexing and quality filtering, OTU picking, taxonomic assignment, and phylogenetic reconstruction, and diversity analyses and visualizations.

## Docker Instalation
First of all, we must to have Docker installed in our computer, here's a quick [step-by-step tutorial](https://docs.docker.com/desktop/windows/install/) of how to install it.

To check if it's installed or not, we open our terminal and write:
```
docker version
```

## Docker Qiime1 Container Session
Our files have the 454 format, so if we want qiime to read them, we need the qiime1 version, a docker container allows us to use that version and instead of creating a docker cointainer with the qiime1 version from the beggining you already can use an existing one from the [hohonuuli/qiime1 repository](https://github.com/hohonuuli/qiime1).
 
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
If we stop working in the interactive session for a while, we have to create a new one and delete the other one, here are some commands that can help us to do these actions:

Docker command to list the running containers:
```
docker ps -a
```
Command to start and stop a container:
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
Output:
```
1A_Suaeda_soil_DEC_CDhit454_clusters.uc  2A_ATCA_soil_DEC_CDhit454_otus.log         3A_Suaeda_litter_DEC_CDhit454_otus.txt     4B_ATCA_litter_APR_CDhit454_clusters.uc  5B_ATCA_litter_AGO_CDhit454_otus.log
1A_Suaeda_soil_DEC_CDhit454_otus.log     2A_ATCA_soil_DEC_CDhit454_otus.txt         3B_Suaeda_litter_APR_CDhit454_clusters.uc  4B_ATCA_litter_APR_CDhit454_otus.log     5B_ATCA_litter_AGO_CDhit454_otus.txt
1A_Suaeda_soil_DEC_CDhit454_otus.txt     2B_ATCA_soil_APR_CDhit454_clusters.uc      3B_Suaeda_litter_APR_CDhit454_otus.log     4B_ATCA_litter_APR_CDhit454_otus.txt     ATCAseed_CDhit454_clusters.uc
1B_Suaeda_soil_APR_CDhit454_clusters.uc  2B_ATCA_soil_APR_CDhit454_otus.log         3B_Suaeda_litter_APR_CDhit454_otus.txt     5A_ATCA_soil_AGO_CDhit454_clusters.uc    ATCAseed_CDhit454_otus.log
1B_Suaeda_soil_APR_CDhit454_otus.log     2B_ATCA_soil_APR_CDhit454_otus.txt         4A_ATCA_litter_DEC_CDhit454_clusters.uc    5A_ATCA_soil_AGO_CDhit454_otus.log       ATCAseed_CDhit454_otus.txt
1B_Suaeda_soil_APR_CDhit454_otus.txt     3A_Suaeda_litter_DEC_CDhit454_clusters.uc  4A_ATCA_litter_DEC_CDhit454_otus.log       5A_ATCA_soil_AGO_CDhit454_otus.txt       
2A_ATCA_soil_DEC_CDhit454_clusters.uc    3A_Suaeda_litter_DEC_CDhit454_otus.log     4A_ATCA_litter_DEC_CDhit454_otus.txt       5B_ATCA_litter_AGO_CDhit454_clusters.uc

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
Output:
```
1A_Suaeda_soil_DEC_CDhit454_tax_assignments.log  1A_Suaeda_soil_DEC_CDhit454_tax_assignments.txt  heatmap.pdf  otu_table.biom
```
If we want to generate it as a PNG:
```
make_otu_heatmap.py -i otu_table.biom -o heatmap.png -g png
```
