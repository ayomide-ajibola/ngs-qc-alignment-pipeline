# Automated Next-Generation Sequencing (NGS) Quality Control & Alignment Pipeline

[![Linux](https://img.shields.io/badge/Platform-Linux%20%2F%20WSL-blue.svg)](https://ubuntu.com)
[![Bioinformatics](https://img.shields.io/badge/Domain-Bioinformatics%20%26%20Genomics-green.svg)](#)
[![Tools](https://img.shields.io/badge/Stack-FastQC%20%7C%20fastp%20%7C%20Samtools%20%7C%20BWA%20%7C%20IGV-orange.svg)](#)

A high-throughput, reproducible computational pipeline for Next-Generation Sequencing (NGS) pre-processing, adapter trimming, quality assurance, and reference sequence alignment.

---

## Key Highlights & Benchmarks
- **High-Throughput Processing**: Benchmarked on over **19.6 Million paired-end reads** (NCBI SRA SRR2061397 & SRR2061398).
- **Quality Elevation**: Elevated base quality from raw sequencing reads to **98.8% Q20** and **95.1% Q30**, removing 160,000+ adapter-contaminated reads and 4.2M degraded bases.
- **Deduplication**: Reduced sequence duplication rates to 3.3% using automated optical/PCR duplicate removal via `samtools markdup`.
- **Comparative Alignment**: Implemented paired-end alignment against the *E. coli* K-12 MG1655 reference genome using both **BWA-MEM** and **Bowtie2**.
- **Interactive Visualization**: Formatted coordinate-sorted, indexed BAM files for structural variant inspection in the **Integrative Genomics Viewer (IGV)**.
- **Reproducibility**: Integrated automated MD5 checksum generation and directory manifests for compliance with FAIR bioinformatics standards.

---

## Pipeline Architecture

```
Raw FASTQ Pairs (19.6M+ reads)
       │
       ▼
[ FastQC Diagnostic Evaluation ] ──► Raw MultiQC Interactive Report
       │
       ▼
[ fastp / Trimmomatic Trimming ] ──► Adapter Removal & Quality Trimming (Q20/Q30)
       │
       ▼
[ Post-Trim QC Evaluation ] ───────► MultiQC Clean Summary Dashboard
       │
       ▼
[ BWA-MEM / Bowtie2 Alignment ] ──► Reference Genome Mapping (.sam)
       │
       ▼
[ Samtools Processing ] ───────────► Fixmate ──► Coordinate Sort ──► Markdup ──► Index (.bam / .bai)
       │
       ▼
[ IGV Visual Inspection ] ─────────► Coverage Depth & Variant Verification
```

---

## Toolchain & Versions
| Software | Version | Purpose |
|---|---|---|
| **FastQC** | `v0.12.1` | Per-base sequence quality & adapter content analysis |
| **fastp** | `0.23.4` | Ultra-fast poly-G tail / adapter trimming & quality filtering |
| **Trimmomatic** | `0.39` | Sliding-window quality thresholding |
| **Samtools** | `1.19.2` | BAM manipulation, sorting, duplicate marking, indexing |
| **BWA / Bowtie2** | `0.7.17 / 2.5` | High-accuracy paired-end genomic alignment |
| **MultiQC** | `1.18` | Unified aggregate reporting across all samples |
| **IGV** | `v2.16+` | Genomic track and BAM visualization |

---

## Getting Started

### Prerequisites
Install the required packages in Ubuntu/WSL:
```bash
sudo apt update && sudo apt install -y fastqc samtools bwa bowtie2
pip install multiqc
```

### Running QC and Trimming
```bash
bash scripts/run_qc_trim.sh data/
```

### Running Genomic Alignment
```bash
bash scripts/run_alignment.sh reference/ecoliK12MG1655_ensembl.fna data/sample_R1.fastq data/sample_R2.fastq
```

### Reproducibility Verification
Generate the audit manifest with MD5 checksums:
```bash
bash scripts/generate_manifest.sh
```

---

## Author
**Ayomide Ajibola**  
M.S. in Computational Science & Engineering, Kean University  
- GitHub: [@ayomide-ajibola](https://github.com/ayomide-ajibola)
- LinkedIn: [Ayomide Ajibola](https://www.linkedin.com/in/ayomide-a-70396319b)
