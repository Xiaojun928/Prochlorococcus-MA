#!/bin/bash
#SBATCH -n 1
#1. imposed nucleotides on aligned protein sequences
#2. extract four-fold degenerate sites for each gene family
#3. estimate the Pis for each gene family and get the median Pis for each 10 replicates (Pis_simu.txt)
#usage: ./s5.cal_Pis.sh /absolute/path/of/your/simlations/
dir1=$1
for n in {1..10}
do
	dir2=`ls -d $dir1/ErrMax_Cuton_Cmpon/round${n}/core_genes/`
	rm $dir2/OG*sh
	perl impose.DNA.on.pep_alignment.pl $dir2
	perl get4fold.pl $dir2
	for j in `ls ${dir2}/*fas`
	do
		python Pis_cal.py $j >> ${dir2}/Pis_Long.txt
	done
	perl -ne 'BEGIN{use List::Util qw(sum);use POSIX;sub median{sum((sort { $a <=> $b } @_ )[int($#_/2), ceil($#_/2)])/2;}}  chomp;($a,$b)=split "\t";push @a,$b; END{$med=median(@a);print "$med\n"}' ${dir2}/Pis_Long.txt >> $dir1/Pis_simu.txt
done


