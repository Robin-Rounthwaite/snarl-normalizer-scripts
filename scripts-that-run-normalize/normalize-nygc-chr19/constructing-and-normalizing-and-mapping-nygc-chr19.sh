#!/bin/bash
set -ex
cd /private/groups/patenlab/rrounthw/vg/
git pull
. ./source_me.sh && make -j 20
cd /private/groups/patenlab/rrounthw/nygc/

# mkdir -p chr19

# # extract chr21 component (no longer necessary since Glenn told me which paths I needed to use.)
# nice time vg chunk -x nygc_snp1kg_grch38.pg -Cp chr19 > chr19/nygc_snp1kg_grch38.chr19.pg

cd chr19

mkdir -p chr19-from-scratch

cd chr19-from-scratch

vg construct -a -r ../sim-hg002-reads/chr19.fa.gz -v ../CCDG_14151_B01_GRM_WGS_2020-08-05_chr19.filtered.shapeit2-duohmm-phased.vcf.gz > nygc.chr19.vg

vg stats -F nygc.chr19.vg # to see if it's a pg.

vg convert -p nygc.chr19.vg > nygc.chr19.pg

# wget https://storage.googleapis.com/cmarkell-vg-wdl-dev/giraffe_manuscript_data/genome_references/graph_references/1000gp_data_nygc_phased/CCDG_14151_B01_GRM_WGS_2020-08-05_chr19.filtered.shapeit2-duohmm-phased.vcf.gz

# wget https://storage.googleapis.com/cmarkell-vg-wdl-dev/giraffe_manuscript_data/genome_references/graph_references/1000gp_data_nygc_phased/CCDG_14151_B01_GRM_WGS_2020-08-05_chr19.filtered.shapeit2-duohmm-phased.vcf.gz.tbi

# Prepare the GBWT of haplotypes
nice time vg gbwt -x nygc.chr19.pg -v ../CCDG_14151_B01_GRM_WGS_2020-08-05_chr19.filtered.shapeit2-duohmm-phased.vcf.gz -o nygc.chr19.variants.gbwt

# Prepare an additional GBWT of the graph's embedded paths
nice time vg gbwt -x nygc.chr19.pg -E -o nygc.chr19.paths.gbwt

# Combine into one GBWT
nice time vg gbwt -m nygc.chr19.gbwt nygc.chr19.paths.gbwt -o nygc.chr19.combined.gbwt

# Make the gbwt graph
nice time vg gbwt -g nygc.chr19.combined.gbwt.gg nygc.chr19.combined.gbwt

# #todo: check to see if the gbwt has the reference path chr19 that I want.
nice time vg paths -Lg nygc.chr19.combined.gbwt > nygc.chr19.combined.gbwt.paths.txt

nice time vg index -j nygc.chr19.dist nygc.chr19.pg

# #todo: make the giraffe gbwt! and then the minimizer uses that gbwt: only a sampled-path-cover, not the full.)
# nice time vg minimizer -g nygc_snp1kg_grch38.chr19.gbwt -d nygc_snp1kg_grch38.chr19.dist -o nygc_snp1kg_grch38.chr19.min nygc_snp1kg_grch38.chr19.pg

#### normalize

#make the segregated-regions graph.
nice time vg normalize -g nygc.chr19.gbwt -r nygc.chr19.gbwt.gg -d nygc.chr19.dist -s nygc.chr19.segregated-regions.data.txt -o nygc.chr19.segregated-regions.gbwt nygc.chr19.pg > nygc.chr19.segregated-regions.pg

#create the gbwt graph:
vg gbwt -g nygc.chr19.segregated-regions.gbwt.gg -x nygc.chr19.segregated-regions.pg nygc.chr19.segregated-regions.gbwt

#normalize the segregated-regions graph.
nice time vg normalize --run_tests -t 20 -g nygc.chr19.segregated-regions.gbwt -r nygc.chr19.segregated-regions.gbwt.gg -d nygc.chr19.dist -S nygc.chr19.segregated-regions.data.txt -o nygc.chr19.segregated-regions.gbwt nygc.chr19.segregated-regions.pg > nygc.chr19.desegregated.normalized.pg

#### simulate reads from hg002 version of the graph.
# done with /home/robin/paten_lab/vg-team/vg/robin-scripts/mapping-and-evaluating-sim-reads/creating-hg002-grch38-chr19-graph-and-sim-reads.sh

#### mapping experiment.

####scratch/junk:
#scp for chr19 files from mustard to local.
# nygc_snp1kg_grch38.chr19.gbwt -r nygc_snp1kg_grch38.chr19.gbwt.gg -d nygc_snp1kg_grch38.chr19.dist -S nygc_snp1kg_grch38.chr19.segregated-regions.data.txt -o nygc_snp1kg_grch38.chr19.segregated-regions.gbwt nygc_snp1kg_grch38.chr19.segregated-regions.pg > nygc_snp1kg_grch38.chr19.desegregated.normalized.pg


# scp rrounthw@mustard:/private/groups/patenlab/rrounthw/nygc/chr19/nygc_snp1kg_grch38.chr19.* .



# # #### preparation for normalize

# ##proper vg gbwt indexing (includes the variants and the reference)


# # gunzip -c CCDG_14151_B01_GRM_WGS_2020-08-05_chr19.filtered.shapeit2-duohmm-phased.vcf.gz > CCDG_14151_B01_GRM_WGS_2020-08-05_chr19.filtered.shapeit2-duohmm-phased.vcf

# nice time vg gbwt -v CCDG_14151_B01_GRM_WGS_2020-08-05_chr19.filtered.shapeit2-duohmm-phased.vcf.gz -x nygc_snp1kg_grch38.chr19.pg -o nygc_snp1kg_grch38.chr19.variants.gbwt

# # nice time vg gbwt --index-paths -x nygc_snp1kg_grch38.chr19.pg -o nygc_snp1kg_grch38.chr19.ref-only.gbwt 
# mv nygc_snp1kg_grch38.chr19.gbwt nygc_snp1kg_grch38.chr19.ref-only.gbwt #did this instead of above line.

# nice time vg gbwt -m -o nygc_snp1kg_grch38.chr19.full.gbwt -g nygc_snp1kg_grch38.chr19.full.gbwt.gg nygc_snp1kg_grch38.chr19.ref-only.gbwt nygc_snp1kg_grch38.chr19.variants.gbwt

# nice time vg normalize -g nygc_snp1kg_grch38.chr19.full.gbtw -r nygc_snp1kg_grch38.chr19.full.gbwt.gg -d nygc_snp1kg_grch38.chr19.dist -s nygc_snp1kg_grch38.chr19.segregated-regions.data.txt -o nygc_snp1kg_grch38.chr19.segregated-regions.gbwt nygc_snp1kg_grch38.chr19.pg > nygc_snp1kg_grch38.chr19.segregated-regions.pg
# 

# #create the gbwt graph:
# vg gbwt -g nygc_snp1kg_grch38.chr19.segregated-regions.gbwt.gg -x nygc_snp1kg_grch38.chr19.segregated-regions.pg nygc_snp1kg_grch38.chr19.segregated-regions.gbwt

# #normalize the segregated-regions graph.
# nice time vg normalize --run_tests -t 20 -g nygc_snp1kg_grch38.chr19.segregated-regions.gbwt -r nygc_snp1kg_grch38.chr19.segregated-regions.gbwt.gg -d nygc_snp1kg_grch38.chr19.dist -S nygc_snp1kg_grch38.chr19.segregated-regions.data.txt -o nygc_snp1kg_grch38.chr19.segregated-regions.gbwt nygc_snp1kg_grch38.chr19.segregated-regions.pg > nygc_snp1kg_grch38.chr19.desegregated.normalized.pg
