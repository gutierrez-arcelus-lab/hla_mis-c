#!/usr/bin/bash

#SBATCH -N 1
#SBATCH -c 8
#SBATCH --mem=48gb
#SBATCH --time=24:00:00
#SBATCH -p bch-compute
#SBATCH --array=1-6
#SBATCH --job-name=STAR
#SBATCH --mail-user=vitor.aguiar@childrens.harvard.edu
#SBATCH --mail-type=END,FAIL
#SBATCH -o /temp_work/ch229163/log/STAR.%A-%a

source /programs/biogrids.shrc
export STAR_X=2.7.9a
export SAMTOOLS_X=1.17

# INPUT
META=${SLURM_SUBMIT_DIR}/sample_description.tsv
FQDIR=${SLURM_SUBMIT_DIR}/fastq/QC
SAMPLE=$( awk -v ARRID="$SLURM_ARRAY_TASK_ID" 'FNR==ARRID { print $1 }' $META )
FQ1=${FQDIR}/$( awk -v ARRID="$SLURM_ARRAY_TASK_ID" 'FNR==ARRID { print $2 }' $META )
FQ2=${FQDIR}/$( awk -v ARRID="$SLURM_ARRAY_TASK_ID" 'FNR==ARRID { print $3 }' $META )
FQ1QC=${FQ1}_val_1.fq.gz
FQ2QC=${FQ2}_val_2.fq.gz
INDEX=${SLURM_SUBMIT_DIR}/STARINDEX

# OUT
OUT=${SLURM_SUBMIT_DIR}/mapping/${SAMPLE}

STAR --runMode alignReads \
    --runThreadN $SLURM_CPUS_PER_TASK \
    --genomeDir $INDEX \
    --readFilesIn $FQ1QC $FQ2QC \
    --readFilesCommand zcat \
    --outFilterMismatchNmax 999 \
    --outFilterMismatchNoverReadLmax 0.04 \
    --outFilterMultimapNmax 20 \
    --outSAMtype BAM SortedByCoordinate \
    --outSAMunmapped Within KeepPairs \
    --outFileNamePrefix ${OUT}_

samtools index ${OUT}_Aligned.sortedByCoord.out.bam
