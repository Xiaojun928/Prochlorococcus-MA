#!/bin/bash
#SBATCH -n 1
#get the sequences (both protein and nucleotides) for each gene family
#usage: ./s4.get_aln.sh /absolute/path/of/your/simlations/

dir1=$1
for n in {1..10}
do
	dir2=`ls -d $dir1/ErrMax_Cuton_Cmpon/round${n}/`
	perl extract_seq_for_scp.pl $dir2
	for i in `ls -r ${dir2}/core_genes/*faa`
	do
		j=$(basename $i .faa)
                echo "#!/bin/bash" > ${dir2}/core_genes/$j.aln.sh
                echo -e "#SBTACH -n 1\\n" >> ${dir2}/core_genes/$j.aln.sh
                echo "time einsi ${dir2}/core_genes/${j}.faa > ${dir2}/core_genes/${j}.mafft.msa" >> ${dir2}/core_genes/$j.aln.sh #multiple sequences alignment
                echo "seqtk seq -l0 ${dir2}/core_genes/${j}.mafft.msa > ${dir2}/core_genes/$j.msa" >> ${dir2}/core_genes/$j.aln.sh
                echo "mv ${dir2}/core_genes/$j.msa ${dir2}/core_genes/${j}.mafft.msa" >> ${dir2}/core_genes/$j.aln.sh
                chmod +x ${dir2}/core_genes/$j.aln.sh
                sbatch ${dir2}/core_genes/$j.aln.sh

	done
done

