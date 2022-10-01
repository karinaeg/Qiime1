#docker run --name qiime1 -v $(pwd):/mnt/data -i -t mbari/qiime1 /bin/bash
source activate qiime1
#File=1B_Suaeda_soil_APR_CDhit454.fasta
#basename "$File"
#!/bin/sh
#script file
input=$1 
Carpeta=$2

echo Carpeta $input $Carpeta
cd $Carpeta
#echo dondeestoy $pwd
#1B_Suaeda_soil_APR_CDhit454.fasta
#cut -f 1 -d '.' $file
File=$(echo $input|cut -f 1 -d '.')

echo $File

#Siguiedo los pasos del tutorial

echo validate_mapping_file.py -m Fasting_Map.txt -o mapping_output
validate_mapping_file.py -m Fasting_Map.txt -o mapping_output

echo split_libraries.py -m Fasting_Map.txt -f Fasting_Example.fna -q Fasting_Example.qual -o split_library_output
split_libraries.py -m Fasting_Map.txt -f Fasting_Example.fna -q Fasting_Example.qual -o split_library_output

echo pick_otus.py -i split_library_output/seqs.fna -o picked_otus_default
pick_otus.py -i split_library_output/seqs.fna -o picked_otus_default

echo pick_rep_set.py -i seqs_otus.txt -f split_library_output/seqs.fna -o rep_set1.fna
pick_rep_set.py -i picked_otus_default/seqs_otus.txt -f split_library_output/seqs.fna -o rep_set1.fna

echo assign_taxonomy.py -i rep_set1.fna -r ref_seq_set.fna -t id_to_taxonomy.txt


exit

align_seqs.py -i $PWD/unaligned.fna -t $PWD/core_set_aligned.fasta.imputed -o $PWD/pynast_aligned_defaults/

filter_alignment.py -i seqs_rep_set_aligned.fasta -o filtered_alignment/

make_phylogeny.py -i $PWD/aligned.fasta -o $PWD/rep_phylo.tre

make_otu_table.py -i otu_map.txt -t tax_assignments.txt -o otu_table.biom

pick_otus.py -i rawdata/$input -o $File-picked_otus_default

exit

#assign_taxonomy.py -i rawdata/$File\.fasta -o $File-assignedtax

#make_otu_table.py -i $File-picked_otus_default/$File\_otus.txt -t $File-assignedtax/$File\_tax_assignments.txt -o otu_table.biom

#make_otu_heatmap.py -i otu_table.biom -o heatmap.pdf #aqui ya no sale

# pick_de_novo_otus.py -i rawdata/$File -o $File-otus

