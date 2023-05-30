#!/usr/bin/bash

#SBATCH -N 1
#SBATCH -c 4
#SBATCH --mem=16gb
#SBATCH --time=24:00:00
#SBATCH -p bch-compute
#SBATCH --array=1-6
#SBATCH --job-name=FASTQC
#SBATCH --mail-user=vitor.aguiar@childrens.harvard.edu
#SBATCH --mail-type=END,FAIL
#SBATCH -o /temp_work/ch229163/log/FASTQC.%A-%a

source /programs/biogrids.shrc
export CUTADAPT_X=4.1
export FASTQC_X=0.11.9
export PYTHON_X=3.8.8

# INPUT
META=${SLURM_SUBMIT_DIR}/sample_description.tsv
FQDIR=${SLURM_SUBMIT_DIR}/fastq 
SAMPLE=$( awk -v ARRID="$SLURM_ARRAY_TASK_ID" 'FNR==ARRID { print $1 }' $META )
FQ1=${FQDIR}/$( awk -v ARRID="$SLURM_ARRAY_TASK_ID" 'FNR==ARRID { print $2 }' $META )
FQ2=${FQDIR}/$( awk -v ARRID="$SLURM_ARRAY_TASK_ID" 'FNR==ARRID { print $3 }' $META )

# OUT
OUT=${FQDIR}/QC

trim_galore --paired \
    --length 50 \
    --fastqc \
    --cores $SLURM_CPUS_PER_TASK \
    -o $OUT \
    $FQ1 $FQ2

