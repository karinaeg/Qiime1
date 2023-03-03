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
It has to show something like this: 
```
 Cloud integration: v1.0.24
 Version:           20.10.14
 API version:       1.41
 Go version:        go1.16.15
 Git commit:        a224090
 Built:             Thu Mar 24 01:53:11 2022
 OS/Arch:           windows/amd64
 Context:           default
 Experimental:      true
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
Commando to start and stop all containers:
```
docker stop $(docker ps -a -q)
docker start $(docker ps -a -q)
```
Command to delete a container:
```
docker rm <<container_id>>
```
Command to delete all containers:
```
docker rm $(docker ps -a -q)
```
## Using Qiime1
### Validate Mapping file
We have to make sure that the mapping file is formatted correctly
```
validate_mapping_file.py -m Fasting_Map.txt -o mapping_output
```
Output:

```
Fasting_Map.html  Fasting_Map.log  Fasting_Map_corrected.txt  overlib.js
```

### Assign taxonomy to each sequence
We need to use the `assign_taxonomy.py` script, it attempts to assign the taxonomy of each sequence given. Currently the methods implemented are assignment. In this case, in this case, we are going to use the uclust consensus taxonomy assigner (default):
```
assign_taxonomy.py -i seqs.fasta
```
### OTU picking
We have to assigns similar sequences to operational taxonomic units, or OTUs, by clustering sequences based on a user-defined similarity threshold. Sequences which are similar at or above the threshold level are taken to represent the presence of a taxonomic unit in the sequence collection. These actions can be executed with the `pick_otus.py` script. It generes a `.log`,`.txt` and a `.uc` file.

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
Output:
```
otu_table.biom
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
Output:
```
1A_Suaeda_soil_DEC_CDhit454_tax_assignments.log  1A_Suaeda_soil_DEC_CDhit454_tax_assignments.txt  heatmap.pdf   heatmap.png  otu_table.biom
```
If we are working on a server and we want to visualize the heatmap pdf or png, we can copy it to our local server:
```
scp -r username1@source_host:directory1/heatmap.pdf username2@destination_host:directory2/heatmap.pdf
```

## Alternative way to explore the data
As an alternative to carry out the analyses, the R phyloseq package was used to obtain some graphical representation that provides us with information on the sequences. OTU tables obtained with QIIME were imported and abundance analysis graphs were made.
The script was adapted from [the following lesson](https://carpentries-incubator.github.io/metagenomics/07-phyloseq/index.html).

The first step is to import the libraries that will be used and set the working directory:
```
library("phyloseq")
library("ggplot2")
library("RColorBrewer")
library("patchwork")

setwd("~/qiime/Ruiz-Font")
```

Second step is to import the BIOM file format, obtained by running the `make_otu_table.py` script and explore the result by asking the class of the object created and doing a close inspection of some of its content:

```
merged_metagenomes <- import_biom("/home/karina/qiime/Ruiz-Font/data/otu_table.biom")
class(merged_metagenomes)
```

See the `tax_table` content and remove some unnecessary characters in the OTUs id and put names to the taxonomic ranks, also explore how many phyla the `tax_table` contains:

```
View(merged_metagenomes@tax_table@.Data)
merged_metagenomes@tax_table@.Data <- substring(merged_metagenomes@tax_table@.Data, 4)
colnames(merged_metagenomes@tax_table@.Data)<- c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species")
unique(merged_metagenomes@tax_table@.Data[,"Phylum"])
```
This command allows to see the information about how many sequenced reads corresponding to a certain OTU are in each sample:

```
View(merged_metagenomes@otu_table@.Data)
```
To see the bacterial diversity:
```
merged_metagenomes <- subset_taxa(merged_metagenomes, Kingdom == "Bacteria")
merged_metagenomes
```
This commands helps to have a sense of the evenness:
```
summary(merged_metagenomes@otu_table@.Data)
```
Next step is to convert the number of assigned reads into percentages because metagenomes have different sizes:

```
View(merged_metagenomes@tax_table@.Data)
percentages <- transform_sample_counts(merged_metagenomes, function(x) x*100 / sum(x) )
```
Phyloseq allows to make a taxa visualization more flexible and personalized by making abundance plots of the taxa in the samples. The first exploration is by Genus:
```
percentages_glom <- tax_glom(percentages, taxrank = 'Genus')
View(percentages_glom@tax_table@.Data)
percentages_df <- psmelt(percentages_glom)
absolute_glom <- tax_glom(physeq = merged_metagenomes, taxrank = "Genus")
percentages_df$Genus <- as.character(percentages_df$Genus)
percentages_df$Genus[percentages_df$Abundance < 2] <- "Genus < 0.5% abund."
unique(percentages_df$Genus)
percentages_df$Genus <- as.factor(percentages_df$Genus)
genus_colors_rel<- colorRampPalette(brewer.pal(8,"Dark2")) (length(levels(percentages_df$Genus)))
relative_plot <- ggplot(data=percentages_df, aes(x=Sample, y=Abundance, fill=Genus))+ geom_bar(aes(), stat="identity", position="stack")+ scale_fill_manual(values = genus_colors_rel)

pdf("Genuspercentages.pdf")
relative_plot
dev.off()
```
The second abundance plot is by Family
```
percentages <- transform_sample_counts(merged_metagenomes, function(x) x*100 / sum(x) )
percentages_glom <- tax_glom(percentages, taxrank = 'Family')
View(percentages_glom@tax_table@.Data)
percentages_df <- psmelt(percentages_glom)
absolute_glom <- tax_glom(physeq = merged_metagenomes, taxrank = "Family")
percentages_df$Family<- as.character(percentages_df$Family)
percentages_df$Family[percentages_df$Abundance < 5] <- "Family < 0.5% abund."
unique(percentages_df$Family)
percentages_df$Family <- as.factor(percentages_df$Family)
family_colors_rel<- colorRampPalette(brewer.pal(8,"Dark2")) (length(levels(percentages_df$Family)))
relative_plot <- ggplot(data=percentages_df, aes(x=Sample, y=Abundance, fill=Family))+ geom_bar(aes(), stat="identity", position="stack")+ scale_fill_manual(values = family_colors_rel)

pdf("Familypercentages.pdf")
relative_plot
dev.off()

```
To distinguish the taxa, the identification of the OTUs whose relative abundance is less than 0.5% was changed.
Since the files could be created and they contain information, abundance diagrams of the taxa in our samples were made.
