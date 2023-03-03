library("phyloseq")
library("ggplot2")
library("RColorBrewer")
library("patchwork")

setwd("~/qiime/Ruiz-Font")

merged_metagenomes <- import_biom("/home/karina/qiime/Ruiz-Font/data/otu_table.biom")

class(merged_metagenomes)
View(merged_metagenomes@tax_table@.Data)
merged_metagenomes@tax_table@.Data <- substring(merged_metagenomes@tax_table@.Data, 4)
colnames(merged_metagenomes@tax_table@.Data)<- c("Kingdom", "Phylum", "Class", "Order", "Family", "Genus", "Species")

unique(merged_metagenomes@tax_table@.Data[,"Phylum"])

View(merged_metagenomes@otu_table@.Data)

merged_metagenomes <- subset_taxa(merged_metagenomes, Kingdom == "Bacteria")
merged_metagenomes
summary(merged_metagenomes@otu_table@.Data)


View(merged_metagenomes@tax_table@.Data)

percentages <- transform_sample_counts(merged_metagenomes, function(x) x*100 / sum(x) )
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

