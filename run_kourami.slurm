#!/usr/bin/bash

#SBATCH -N 1
#SBATCH -c 8
#SBATCH --mem=64gb
#SBATCH --time=24:00:00
#SBATCH -p bch-compute
#SBATCH --array=1-6
#SBATCH --job-name=Kourami
#SBATCH --mail-user=vitor.aguiar@childrens.harvard.edu
#SBATCH --mail-type=END,FAIL
#SBATCH -o /temp_work/ch229163/log/Kourami.%A-%a

source /programs/biogrids.shrc
export BAMUTIL_X=1.0.14
export SAMTOOLS_X=1.17
export BWA_X=0.7.17

# INPUT
META=${SLURM_SUBMIT_DIR}/sample_description.tsv
SAMPLE=$( awk -v ARRID="$SLURM_ARRAY_TASK_ID" 'FNR==ARRID { print $1 }' $META )

SCRIPT=/lab-share/IM-Gutierrez-e2/Public/vitor/software/kourami-0.9.6/scripts/alignAndExtract_hs38.sh
KOURAMI=/lab-share/IM-Gutierrez-e2/Public/vitor/software/kourami-0.9.6/build/Kourami.jar
DB=/lab-share/IM-Gutierrez-e2/Public/vitor/software/kourami-0.9.6/db
BAM=${SLURM_SUBMIT_DIR}/hla-mapper/${SAMPLE}/${SAMPLE}.adjusted.bam
OUT=${SLURM_SUBMIT_DIR}/genotype_calls/kourami/${SAMPLE}

$SCRIPT -d $DB $OUT $BAM

/usr/bin/java -jar $KOURAMI -d $DB -o $OUT ${OUT}_on_KouramiPanel.bam

