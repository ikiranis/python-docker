## Overview

There are two types of files in this directory. One is the test files; and the other is the reference files (expected results).

## Explanation of files

### 1. Test files for bcftools and the preprocessing scripts
1. test.vcf.gz
2. reference.Sample_1.vcf
3. reference.Sample_2.vcf
4. reference.missing_pgx_var.vcf.gz


_"test.vcf.gz"_ are designed for tests on bcftools version as well as the PharmCAT VCF preprocessor. The output from the VCF preprocessor should match the content in *reference.Sample_1.vcf*, *reference.Sample_2.vcf*, and *reference.missing_pgx_var.vcf.gz*.

### 2. Test files for the VCF proprocessing script - Performance

I tested the performance of the VCF preprocessing script, including run time, multi-sample VCF processing, etc. 

The data was the 1000 Genomes Project sequences of Coriell samples with corresponding Genetic Testing Reference Materials Coordination Program (GeT-RM) sample characterization. This dataset was generated by Adam Lavertu, Ryan and Mark for the paper, [_Pharmacogenomics Clinical Annotation Tool (PharmCAT)_](https://doi.org/10.1002/cpt.1568); and is hosted on [the Stanford Digital Repository](https://purl.stanford.edu/rd572fp2219). 

```
# Follow the script 01-03 downloaded from the Stanford Digital Repository. You will need to modify the codes, such as file paths.

# run VCF preprocessing
python3 PharmCAT_VCF_Preprocess.py \
--input_vcf PharmCAT_calling_pipeline-master/data/1kg_data/GeT-RM_sample_data/PGx.chrAllPGx.GRCh38.genotypes.20170504.vcf.gz \
--ref_seq GCA_000001405.15_GRCh38_no_alt_analysis_set.fna \
--ref_pgx_vcf pharmcat_positions_0.8.0_updated_06222021.vcf.gz \
--output_prefix pharmcat_ready_vcf
```



