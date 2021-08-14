# Base name for final output files ust a prefix to identify your outputs.
base_name='Staphy_aureus_rnd1'

# Output directory for the final output files.
# This will create the directory if it does not already exist.
final_output_dir=/home-user/xjwang/Proch_pop/SAG_pop_simulation/12_Staphy_aureus_taxa1280/ErrMax_Cuton_Cmpon/round1
mkdir -p ${final_output_dir}

# Path to mugsy and mugsyenv.sh. Please provide absolute path.
mugsy_path=/home-user/software/mugsy_v1r2.3/mugsy
mugsy_env=/home-user/software/mugsy_v1r2.3/mugsyenv.sh

# Path to infomap executable. Please provide absolute path.
infomap_path=/home-user/software/PopCOGenT/Infomap/Infomap

# Path to genome files.
#genome_dir=/home-user/xjwang/Prochlorococcus_MA/Ne_calculation/Prochlorococcus/HLII_0_hetero/
genome_dir=/home-user/xjwang/Proch_pop/SAG_pop_simulation/12_Staphy_aureus_taxa1280/ErrMax_Cuton_Cmpon/round1/

# Genome file filename extension.
genome_ext=.fasta

# Are you running on a single machine? Please specify the number of threads to run.
# This can, at maximum, be the number of logical cores your machine has.
num_threads=10

# Whether to keep alignments after length bias is calculated. 
# Alignment files can be 10MB each and thus a run on 100 genomes can take up on the order of 50 GB of space if alignment files are not discarded. 
# If you want to keep alignments, set to --keep_alignments. Otherwise leave as ''.
#keep_alignments=--keep_alignments
keep_alignments=''

# Directory for output alignments. Must provide absolute path.
alignment_dir=/home-user/xjwang/Proch_pop/SAG_pop_simulation/12_Staphy_aureus_taxa1280/ErrMax_Cuton_Cmpon/round1/pop_aln
mkdir -p ${alignment_dir}

# Are your genomes single-cell genomes? If so, this should equal --single_cell. Otherwise leave as ''.
single_cell='--single_cell'

# Are you using a slurm environment? Then this should equal --slurm, otherwise, leave as empty quotes.
slurm_str='--slurm'

# If using slurm, please specify the output directory for the runscripts and source scripts. Absolute paths required.
script_dir='/mnt/home-user/xjwang/Proch_pop/SAG_pop_simulation/12_Staphy_aureus_taxa1280/ErrMax_Cuton_Cmpon/round1'
source_path='/home-user/software/PopCOGenT/src'
