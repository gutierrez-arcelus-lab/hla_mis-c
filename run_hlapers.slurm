#!/usr/bin/bash

#SBATCH -N 1
#SBATCH -c 12
#SBATCH --mem=64gb
#SBATCH --time=24:00:00
#SBATCH -p bch-compute
#SBATCH --array=1-6
#SBATCH --job-name=HLApers
#SBATCH --mail-user=vitor.aguiar@childrens.harvard.edu
#SBATCH --mail-type=END,FAIL
#SBATCH -o /temp_work/ch229163/log/HLApers.%A-%a

source /programs/biogrids.shrc
export STAR_X=2.7.9a
export SALMON_X=1.5.1
export SAMTOOLS_X=1.17
export SEQTK_X=1.3
export R_X=4.1

HLAPERS=/lab-share/IM-Gutierrez-e2/Public/vitor/software/HLApers/hlapers

# METADATA
META=${SLURM_SUBMIT_DIR}/sample_description.tsv
SAMPLEID=$( awk -v ARRID="$SLURM_ARRAY_TASK_ID" 'FNR==ARRID { print $1 }' $META )

###### BAM TO FASTQ
HLADB=${SLURM_SUBMIT_DIR}/hladb
BAM=${SLURM_SUBMIT_DIR}/mapping/${SAMPLEID}_Aligned.sortedByCoord.out.bam
OUT=${SLURM_SUBMIT_DIR}/genotype_calls/hlapers/${SAMPLEID}

$HLAPERS bam2fq \
    -b $BAM \
    -m ${HLADB}/mhc_coords.txt \
    -o $OUT

##### Genotyping
INDEX=${SLURM_SUBMIT_DIR}/HLAINDEX
TRANSC=${HLADB}/transcripts_MHC_HLAsupp.fa
FQ1=${OUT}_mhc_unmap_1.fq
FQ2=${OUT}_mhc_unmap_2.fq

$HLAPERS genotype \
    -i $INDEX \
    -t $TRANSC \
    -1 $FQ1 -2 $FQ2 \
    -p $SLURM_CPUS_PER_TASK \
    -o ${OUT}

#rm -r $FQ1 $FQ2 ${OUT}_log
