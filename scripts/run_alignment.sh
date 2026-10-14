#!/usr/bin/env bash
# ==============================================================================
# Paired-End Genome Alignment & Samtools Post-Processing (BWA-MEM & Bowtie2)
# Author: Ayomide Ajibola
# ==============================================================================
set -euo pipefail

REF_GENOME=${1:-"reference/ecoliK12MG1655_ensembl.fna"}
R1=${2:-"data/GA2_R1.fastq"}
R2=${3:-"data/GA2_R2.fastq"}
OUT_DIR="alignment_results"

mkdir -p "$OUT_DIR"

echo "=== 1. Indexing Reference Genome ==="
if [ ! -f "${REF_GENOME}.bwt" ]; then
    bwa index "$REF_GENOME"
fi
if [ ! -f "${REF_GENOME}.1.bt2" ]; then
    bowtie2-build "$REF_GENOME" "${REF_GENOME%.*}"
fi

echo "=== 2. Aligning with BWA-MEM ==="
bwa mem -t 4 "$REF_GENOME" "$R1" "$R2" > "$OUT_DIR/aln_pe_bwa.sam"

echo "=== 3. Samtools Sort, Fixmate, Markdup, Index (BWA) ==="
samtools view -bS "$OUT_DIR/aln_pe_bwa.sam" | samtools sort -n -o "$OUT_DIR/aln_pe_bwa_namesorted.bam"
samtools fixmate -m "$OUT_DIR/aln_pe_bwa_namesorted.bam" "$OUT_DIR/aln_pe_bwa_fixmate.bam"
samtools sort -o "$OUT_DIR/aln_pe_bwa_sorted.bam" "$OUT_DIR/aln_pe_bwa_fixmate.bam"
samtools markdup -r "$OUT_DIR/aln_pe_bwa_sorted.bam" "$OUT_DIR/aln_pe_bwa_markdup.bam"
samtools index "$OUT_DIR/aln_pe_bwa_markdup.bam"

echo "Alignment and duplicate marking complete for BWA!"
