#!/bin/bash
set -ex

# files in mustard nygc:
#        4096 chr21
#           0 nygc_snp1kg_grch38.combined.n32.segregated-regions.normalized.pg
#  8635164605 nygc_snp1kg_grch38.combined.n32.segregated-regions.gbwt.gg
#   286412337 nygc_snp1kg_grch38.combined.n32.segregated-regions-data.txt
# 18877866912 nygc_snp1kg_grch38.combined.n32.segregated-regions.gbwt
# 12632339617 nygc_snp1kg_grch38.combined.n32.segregated-regions.pg
#       12560 nygc_snp1kg_grch38.78157365-78157368.c4.svg
#           0 nygc_snp1kg_grch38.n32.normalized.pg
#       14930 nygc_snp1kg_grch38.42978513-42978518.c4.svg
# 10471290424 nygc_snp1kg_grch38.new.dist
#  8630556573 nygc_snp1kg_grch38.combined.gbwt.gg
# 18851189640 nygc_snp1kg_grch38.combined.gbwt
#  3510467712 nygc_snp1kg_grch38.paths.gbwt
#     2723148 nygc_snp1kg_grch38.all.gbwt.names.ref-only.txt
#           0 nygc_snp1kg_grch38.pg.names.ref-only.txt
#       66140 nygc_snp1kg_grch38.pg.names.txt
#     2723148 nygc_snp1kg_grch38.all.gbwt.names.txt
#           0 nygc_snp1kg_grch38.n32.segregated-regions.pg
#           0 nygc_snp1kg_grch38.normalized.pg
# 12444632423 nygc_snp1kg_grch38.pg
# 19126440841 nygc_snp1kg_grch38.all.gbwt
#   340304859 nygc_snp1kg_grch38.snarls.pb
# 13737453235 nygc_snp1kg_grch38.vg
# 14508436717 nygc_snp1kg_grch38.dist
#  8501915547 nygc_snp1kg_grch38.gg
# 27611457814 nygc_snp1kg_grch38.min
#  4216178253 nygc_snp1kg_grch38.N64-giraffe.gbwt


# January 15th 2024 
# On Screen 0:
# for full genome:
cd /private/groups/patenlab/rrounthw/vg &&
# git checkout robin-investigate-slow-nygc-snarls
git pull && . ./source_me.sh && make -j 20 &&
cd /private/groups/patenlab/rrounthw/nygc/ &&
#below is the single-snarl normalize run that I want to test debugging on:
nice time vg normalize --run_tests --skip_desegregate -g nygc_snp1kg_grch38.combined.n32.segregated-regions.gbwt -r nygc_snp1kg_grch38.combined.n32.segregated-regions.gbwt.gg -t 30 -n 32 -o nygc_snp1kg_grch38.combined.n32.desegregated.normalized.gbwt -S segregated-regions-data.normalize-244496945-244496959-only.txt nygc_snp1kg_grch38.combined.n32.segregated-regions.pg > nygc_snp1kg_grch38.combined.n32.desegregated.normalized.pg
#below is the full normalize run that I want to run after debugging:
# nice time vg normalize --run_tests -g nygc_snp1kg_grch38.combined.n32.segregated-regions.gbwt -r nygc_snp1kg_grch38.combined.n32.segregated-regions.gbwt.gg -t 30 -n 32 -o nygc_snp1kg_grch38.combined.n32.desegregated.normalized.gbwt -S nygc_snp1kg_grch38.combined.n32.segregated-regions-data.txt nygc_snp1kg_grch38.combined.n32.segregated-regions.pg > nygc_snp1kg_grch38.combined.n32.desegregated.normalized.pg

#note: outdated version of creation of segregated-regions, kept for records:
# nice vg normalize --run_tests -d nygc_snp1kg_grch38.new.dist -g nygc_snp1kg_grch38.all.gbwt -r nygc_snp1kg_grch38.gg -t 20 -n 32 --debug_print --run_tests -o nygc_snp1kg_grch38.n32.segregated-regions.gbwt -s nygc_snp1kg_grch38.n32.segregated-regions-data.txt nygc_snp1kg_grch38.pg > nygc_snp1kg_grch38.n32.segregated-regions.pg
# time vg gbwt -g nygc_snp1kg_grch38.n32.segregated-regions.gbwt.gg -x nygc_snp1kg_grch38.n32.segregated-regions.vg nygc_snp1kg_grch38.n32.segregated-regions.gbwt &&

#### read mapping


# #### variant calling (from /home/robin/paten_lab/vg-team/vg/kubernetes_jobs/snarl_normalization/2023-06-20.sveval-unnormalized-graph.yml)
#           BIN_VERSION="1.5.0"
#           docker run \
#             -v "$(pwd)":"/io" \
#             google/deepvariant:"${BIN_VERSION}" \
#             /opt/deepvariant/bin/run_deepvariant \
#             --model_type=WGS \
#             --ref=/io/hg38.fa \
#             --reads=/io/hg38-hsvlr_srdedup17_aug.robin-giraffe-29k11w32N.bam \
#             --output_vcf=/io/hg38-hsvlr_srdedup17_aug.robin-giraffe-29k11w32N.deepvariant.vcf \
#             --output_gvcf=/io/hg38-hsvlr_srdedup17_aug.robin-giraffe-29k11w32N.deepvariant.gvcf \
#             --num_shards=$(nproc) \ 
#             --logging_dir=/io/unnormalized-logs \
#             --dry_run=false