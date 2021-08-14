#!/bin/bash
#prerequisites: isolates have been stored in the $dir1
#usage: nohup ./s0.SAG_simulation.sh /absolute/path/of/your/isolates/genomes &>your_taxa.out&
dir1=$1;
mkdir -p $dir1/ErrMax_Cuton_Cmpon/
dir2=`ls -d $dir1/ErrMax_Cuton_Cmpon/`

#1. prepare for inputs
cp SAG_simu.pl ./example/length_distribution.txt ./example/completeness_distribution.txt $dir2/
cd $dir1
ls *fna > $dir2/genome_list.txt

#2. simulate SAGs with all isolates for 10 replicates
cd $dir2
perl SAG_simu.pl

for i in {1..10}
do
	mkdir round${i}
	mv *round${i}.fasta round${i}
done

#3. run PopCOGenT for each replicates
cp ../../*simu.sh ./
#below is an example based on the provided config_simu.sh, 
#please change the path in config_simu.sh and PopCOGenT_simu.sh according to your system
sed -i "s/Staphy_aureus_rnd/your_taxa_rnd/g" config_*
sed -i "s/12_Staphy_aureus_taxa1280/your_taxa_taxaid/g" config_*

#replicate files
for i in {2..10}
do 
	cp config_simu.sh config_simu_rnd${i}.sh
	cp PopCOGenT_simu.sh PopCOGenT_simu_rnd${i}.sh 
	sed -i "s/round1/round${i}/g" config_simu_rnd${i}.sh
	sed -i "s/rnd1/rnd${i}/" config_simu_rnd${i}.sh
	sed -i "s/_simu/_simu_rnd${i}/" PopCOGenT_simu_rnd${i}.sh
done

#submit jobs
for i in `ls PopCOGenT_simu*`; do sbatch $i; done


