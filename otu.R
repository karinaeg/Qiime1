library("phyloseq")
library("ggplot2")
library("RColorBrewer")
library("patchwork")


setwd("~/qiime/Ruiz-Font/data/")

merged_metagenomes <- import_biom("otu_table.biom")

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
percentages_glom <- tax_glom(percentages, taxrank = 'Phylum')
View(percentages_glom@tax_table@.Data)

percentages_df <- psmelt(percentages_glom)
absolute_glom <- tax_glom(physeq = merged_metagenomes, taxrank = "Phylum")
absolute_df <- psmelt(absolute_glom)
absolute_df$Phylum <- as.factor(absolute_df$Phylum)
phylum_colors_abs<- colorRampPalette(brewer.pal(8,"Dark2")) (length(levels(absolute_df$Phylum)))
absolute_plot <- ggplot(data= absolute_df, aes(x=Sample, y=Abundance, fill=Phylum))+ geom_bar(aes(), stat="identity", position="stack")+ scale_fill_manual(values = phylum_colors_abs)
percentages_df$Phylum <- as.factor(percentages_df$Phylum)
phylum_colors_rel<- colorRampPalette(brewer.pal(8,"Dark2")) (length(levels(percentages_df$Phylum)))
relative_plot <- ggplot(data=percentages_df, aes(x=Sample, y=Abundance, fill=Phylum))+ geom_bar(aes(), stat="identity", position="stack")+ scale_fill_manual(values = phylum_colors_rel)
pdf("rplot.pdf")
absolute_plot | relative_plot
dev.off()



  
  

