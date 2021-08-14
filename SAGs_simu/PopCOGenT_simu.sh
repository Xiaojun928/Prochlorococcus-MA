#!/bin/bash
#SBATCH -n 10
#source  activate /home-user/xjwang/miniconda3/envs/PopCOGenT
configfile=./config_simu.sh
source ${configfile}
#source activate PopCOGenT
source ${mugsy_env}

python /home-user/software/PopCOGenT/src/PopCOGenT/get_alignment_and_length_bias.py --genome_dir ${genome_dir} --genome_ext ${genome_ext} --alignment_dir ${alignment_dir} --mugsy_path ${mugsy_path} --mugsy_env ${mugsy_env} --base_name ${base_name} --final_output_dir ${final_output_dir} --num_threads ${num_threads} ${keep_alignments}
python /home-user/software/PopCOGenT/src/PopCOGenT/cluster.py --base_name ${base_name} --length_bias_file ${final_output_dir}/${base_name}.length_bias.txt --output_directory ${final_output_dir} --infomap_path ${infomap_path} ${single_cell}

#if [ "${slurm_str}" = "" ]
#	then
#		python /home-user/software/PopCOGenT/src/PopCOGenT/get_alignment_and_length_bias.py --genome_dir ${genome_dir} --genome_ext ${genome_ext} --alignment_dir ${alignment_dir} --mugsy_path ${mugsy_path} --mugsy_env ${mugsy_env} --base_name ${base_name} --final_output_dir ${final_output_dir} --num_threads ${num_threads} ${keep_alignments}
#		python /home-user/software/PopCOGenT/src/PopCOGenT/cluster.py --base_name ${base_name} --length_bias_file ${final_output_dir}/${base_name}.length_bias.txt --output_directory ${final_output_dir} --infomap_path ${infomap_path} ${single_cell}
#fi
