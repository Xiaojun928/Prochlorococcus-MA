#!/bin/bash
#SBATCH -n 16

#	usage
echo "sh this.sh"
echo "require concat.phy files namely concat.phy in .\n\n"

#	initialization
/home-user/software/FastTree/FastTree concat.fasta > fasttree.tre

#python /home-user/xyfeng/database/fasta2phylip/ElConcatenero-master/ElConcatenero.py -c -of phylip -in concat.fasta
time /home-user/software/iqtree/iqtree -nt 16 -m MFP -alrt 1000 -bb 1000 -s concat.fasta -redo -mset WAG,LG,JTT,Dayhoff -mrate E,I,G,I+G -mfreq FU -wbtl -pre iqtree -spp partition_file.txt
#for 3 genomes
#iqtree -m MFP -s concat.phy -redo -mset WAG,LG,JTT,Dayhoff -mrate E,I,G,I+G -mfreq FU -wbtl -pre iqtree
