#!/bin/bash
#1. get the annotated faa(protein) and ffn (nucleotides) files for each simulated SAGs
#2. run OrthoFinder to get orthologs
#usage: ./s2.OrthoFinder.sh /absolute/path/of/your/simlations/
#Notes: please provide the path of your OrthoFinder in 'orthoFinder.sh' before run this script

tmp_dir=`pwd`
DIR=$1
for i in {1..10}
do
	mkdir -p $DIR/ErrMax_Cuton_Cmpon/round${i}/00_seq_folder
	mkdir -p $DIR/ErrMax_Cuton_Cmpon/round${i}/nuc
	find $DIR/ErrMax_Cuton_Cmpon/round${i}/reannotation -name "*faa" |xargs -i cp {} $DIR/ErrMax_Cuton_Cmpon/round${i}/00_seq_folder
	find $DIR/ErrMax_Cuton_Cmpon/round${i}/reannotation -name "*ffn" |xargs -i cp {} $DIR/ErrMax_Cuton_Cmpon/round${i}/nuc
	cp ./orthoFinder.sh $DIR/ErrMax_Cuton_Cmpon/round${i}/
	cd $DIR/ErrMax_Cuton_Cmpon/round${i}/
	sbatch orthoFinder.sh
	cd $tmp_dir
done
