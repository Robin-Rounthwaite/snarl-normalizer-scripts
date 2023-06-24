#in mustard:
# cd /private/groups/patenlab/rrounthw/jean-hg38-hsvlr-srdedup17/
# mkdir sveval

mkdir sveval/vcf
cp hg38-hsvlr_srdedup17_aug.normalized.robin-giraffe-29k11w32N.vcf sveval/vcf/hsvlr-hg002-normalized.vcf
gzip sveval/vcf/hsvlr-hg002-normalized.vcf
cp hg38-hsvlr_srdedup17_aug.robin-giraffe-29k11w32N.vcf sveval/vcf/hsvlr-hg002-unnormalized.vcf
gzip sveval/vcf/hsvlr-hg002-unnormalized.vcf
scp rrounthw@courtyard.gi.ucsc.edu:/public/groups/vg/jmonlong/vgamb/hpp/sveval/giab6_hg38-truth-baseline.norm.vcf.gz sveval/vcf/hsvlr-truth-baseline.vcf.gz

mkdir sveval/bed
wget https://github.com/vgteam/sv-genotyping-paper/blob/master/human/sveval/hg38_non_repeats.bed.gz -O sveval/bed/hg38_non_repeats.bed.gz

cd sveval/

wget http://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/hg38.fa.gz

### The following is what I would do if I didn't have all sorts of quotes in the file contents. Instead, just copy/paste it into the file directly.

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




# cd /private/groups/patenlab/rrounthw/
# git clone https://github.com/jmonlong/sveval.git
# cd sveval


