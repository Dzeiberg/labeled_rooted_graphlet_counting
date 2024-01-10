#!/bin/bash
#SBATCH --job-name=graphlet_counting
#SBATCH --output=output.log
#SBATCH --error=error.log
#SBATCH --partition=debug
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=16G
#SBATCH --time=0:19:00
#SBATCH --array=1-10

module load matlab/R2023a

i=$SLURM_ARRAY_TASK_ID
acc=$(sed "${i}q;d" uniprot_accessions.txt)
ALPHABET_SIZE=40
CA_THRESHOLD=6

inputfile="/work/pedjas_lab/swissprot_graphlets/data/distance_matrices/${acc}.mat"
outputfile="/work/pedjas_lab/swissprot_graphlets/data/graphlet_counts/${acc}.alphabet_${ALPHABET_SIZE}.CA_${CA_THRESHOLD}.mat"
labelsfile="/work/pedjas_lab/swissprot_graphlets/proteins/${acc}/residues.labels"
matlab -nodisplay -nosplash -nodesktop -r "run_main("${inputfile}", "${labelsfile}", "${outputfile}", "${ALPHABET_SIZE}", "${CA_THRESHOLD}");exit;"
