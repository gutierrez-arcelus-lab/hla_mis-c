#!/usr/bin/bash

source /programs/biogrids.shrc
export R_X=4.1
export STAR_X=2.7.9a

WORKDIR=/lab-share/IM-Gutierrez-e2/Public/vitor/mis-c
HLAPERS=${WORKDIR}/HLApers/hlapers
IMGT=${WORKDIR}/IMGTHLA
ANNOT=/lab-share/IM-Gutierrez-e2/Public/References/Annotations/hsapiens/gencode.v38.primary_assembly.annotation.gtf.gz
FASTA=/lab-share/IM-Gutierrez-e2/Public/References/Annotations/hsapiens/gencode.v38.primary_assembly.transcripts.fa 
OUT=${WORKDIR}/hladb
INDEX=${WORKDIR}/HLAINDEX

#$HLAPERS prepare-ref -t $FASTA -a $ANNOT -i $IMGT -o $OUT

$HLAPERS index -t ${OUT}/transcripts_MHC_HLAsupp.fa -p 4 -o $INDEX

