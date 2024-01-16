#in mustard:
# cd /private/groups/patenlab/rrounthw/
# git clone https://github.com/jmonlong/sveval.git
# cd sveval/snakemake

# mkdir sveval

mkdir vcf
#note: the following will interrupt the commands b/c of password required.
scp rrounthw@courtyard.gi.ucsc.edu:/public/groups/vg/jmonlong/vgamb/hpp/sveval/vcf/giab6_hg38-truth-baseline.norm.vcf.gz sveval/vcf/hsvlr-truth-baseline.vcf.gz
cp hg38-hsvlr_srdedup17_aug.normalized.robin-giraffe-29k11w32N.vcf vcf/hsvlr-hg002-normalized.vcf
bgzip vcf/hsvlr-hg002-normalized.vcf
cp hg38-hsvlr_srdedup17_aug.robin-giraffe-29k11w32N.vcf vcf/hsvlr-hg002-unnormalized.vcf
bgzip vcf/hsvlr-hg002-unnormalized.vcf

mkdir bed
wget https://github.com/vgteam/sv-genotyping-paper/raw/master/human/sveval/hg38_non_repeats.bed.gz -O sveval/bed/hg38_non_repeats.bed.gz

#also, get the ref somhow, e.g.:
# wget http://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.fa.gz
# gunzip hg38.fa.gz

docker run -it --rm -v `pwd`:/app -w /app -u `id -u $USER` quay.io/jmonlong/sveval:v2.2.0
#then, run the following command:
snakemake --configfile config.yaml --cores 4






MissingInputException in line 37 of /app/Snakefile:
Missing input files for rule bgzip:
vcf/hsvlr-unnormalized-hg002.norm.vcf



### Note: I would also need to do the following for config.yaml if I didn't have all sorts of quotes in the file contents. Instead, just copy/paste it into the file directly.

# echo "# reference files
# nonrep_bed: "bed/hg38_non_repeats.bed"
# ref_fa: "hg38.fa.gz"
# # vcfs to analyze
# exp: 'hsvlr'
# samples: 'hg002'
# methods: 'unnormalized normalized'
# # output PDF with all the graphs
# out_pdf: 'hsvlr-chr6-unnormalized-normalized.pdf'
# # which type of evaluation?
# #   - 'call' is SV presence/absence
# #   - 'geno' compares actual genotypes
# eval: 'call geno'
# # which SVs to consider?
# #   - 'all' means all genome (i.e. no filtering)
# #   - 'nonrep' means only SVs overlapping non-repeat regions (as defined by *nonrep_bed* above).
# regions: 'all nonrep'
# # should we look for inversions by comparing the sequence of the REF and ALT alleles?
# check_inv: False
# # minimum coverage/reciprocal overlap to match variants from the call-set and truth-set
# min_cov: 0.5" > config.yaml


####################
#sources are
# https://github.com/jmonlong/sveval/tree/master/snakemake
#and jean slack.
