#!/bin/bash
#1. select the population with largest members
#2. protein-coding genes prediction by prokka
#usage ./s1.select_pop_annot_gene.sh /absolute/path/of/your/simlations/

DIR=$1

for i in {1..10}; do perl PopCOGenT_cluster_summary.pl $DIR/ErrMax_Cuton_Cmpon/round${i}; done
for i in {1..10}; do perl reannotation.pl $DIR/ErrMax_Cuton_Cmpon/round${i}; done
