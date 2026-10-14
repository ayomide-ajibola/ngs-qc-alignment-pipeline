#!/usr/bin/env bash
# ==============================================================================
# Automated NGS Read Quality Control & Adapter Trimming Pipeline
# Author: Ayomide Ajibola
# ==============================================================================
set -euo pipefail

DATA_DIR=${1:-"data"}
RAW_QC_DIR="raw_qc"
POST_QC_DIR="post_qc"
TRIMMED_DIR="trimmed"
REPORTS_DIR="reports"

mkdir -p "$RAW_QC_DIR" "$POST_QC_DIR" "$TRIMMED_DIR" "$REPORTS_DIR"

echo "=== 1. Initial Quality Control with FastQC ==="
fastqc "$DATA_DIR"/*.fastq.gz -o "$RAW_QC_DIR"

echo "=== 2. MultiQC Initial Summary ==="
multiqc "$RAW_QC_DIR" -o "$REPORTS_DIR" --title "Raw Reads QC"

echo "=== 3. Quality Filtering and Adapter Trimming with fastp ==="
for r1 in "$DATA_DIR"/*_1.fastq.gz "$DATA_DIR"/*_R1.fastq.gz; do
    [ -e "$r1" ] || continue
    sample_name=$(basename "$r1" | sed -E 's/(_1|_R1)\.fastq\.gz//')
    r2="${r1/_1.fastq.gz/_2.fastq.gz}"
    r2="${r2/_R1.fastq.gz/_R2.fastq.gz}"
    
    echo "Processing sample: $sample_name"
    fastp \
        -i "$r1" -I "$r2" \
        -o "$TRIMMED_DIR/${sample_name}_trimmed_R1.fastq.gz" \
        -O "$TRIMMED_DIR/${sample_name}_trimmed_R2.fastq.gz" \
        -h "$REPORTS_DIR/fastp_${sample_name}.html" \
        -j "$REPORTS_DIR/fastp_${sample_name}.json" \
        --detect_adapter_for_pe \
        --cut_front --cut_tail \
        --qualified_quality_phred 20 \
        --unqualified_percent_limit 40 \
        --length_required 36
done

echo "=== 4. Post-Trimming Quality Control ==="
fastqc "$TRIMMED_DIR"/*.fastq.gz -o "$POST_QC_DIR"

echo "=== 5. Final MultiQC Diagnostic Report ==="
multiqc "$POST_QC_DIR" "$REPORTS_DIR" -o "$REPORTS_DIR" --title "Post-Trimming MultiQC Report"

echo "Pipeline execution finished successfully!"
