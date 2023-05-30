#!/usr/bin/bash

#SBATCH -N 1
#SBATCH -c 8
#SBATCH --mem=128gb
#SBATCH --time=24:00:00
#SBATCH -p bch-largemem
#SBATCH --array=2
#SBATCH --job-name=hla-mapper
#SBATCH --mail-user=vitor.aguiar@childrens.harvard.edu
#SBATCH --mail-type=END,FAIL
#SBATCH -o /temp_work/ch229163/log/hla-mapper.%A-%a

source /programs/biogrids.shrc
export STAR_X=2.7.9a
export SAMTOOLS_X=1.17

HLAMAPPER=/lab-share/IM-Gutierrez-e2/Public/vitor/software/hla-mapper/ver_4.3/bin/linux_64/hla-mapper
DB=/lab-share/IM-Gutierrez-e2/Public/vitor/software/hla-mapper/ver_4.3/db/hla-mapper_db_004.3_HLA

# INPUT
META=${SLURM_SUBMIT_DIR}/sample_description.tsv
SAMPLE=$( awk -v ARRID="$SLURM_ARRAY_TASK_ID" 'FNR==ARRID { print $1 }' $META )
BAM=${SLURM_SUBMIT_DIR}/mapping/${SAMPLE}_Aligned.sortedByCoord.out.bam 
OUT=${SLURM_SUBMIT_DIR}/hla-mapper/${SAMPLE}

$HLAMAPPER rna \
    bam=$BAM \
    sample=$SAMPLE \
    threads=$SLURM_CPUS_PER_TASK \
    db=$DB \
    output=$OUT
