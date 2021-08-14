#!/bin/bash
#1. estimate the average completeness of simulated SAGs in the selected population (s1.select_pop_annot_gene.sh)
#2. selecte orthologous gene families based on above completeness only single-copy gene is allowed for each SAG.
#usage: ./s3.select_OGfam.sh /absolute/path/of/your/simlations/

dir1=$1
#echo $dir1
perl estm_completeness.pl $dir1

for i in {1..10}
do
	dir2=`ls -d $dir1/ErrMax_Cuton_Cmpon/round${i}/00_seq_folder/Results*`
	#echo $dir2
	dir3=`ls -d $dir1/ErrMax_Cuton_Cmpon/round${i}/`
	#echo $dir3
	Rscript select_gene_fam.R $i $dir1 $dir2 $dir3
done
