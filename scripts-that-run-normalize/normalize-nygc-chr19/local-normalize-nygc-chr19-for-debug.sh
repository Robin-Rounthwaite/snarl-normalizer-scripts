#!/bin/bash
set -ex
cd ~/paten_lab/vg-team/vg/
. ./source_me.sh && make -j 14
cd ~/paten_lab/vg-team/vg/robin-graphs/nygc-chr19

#make the segregated-regions graph.
# nice time vg normalize -g nygc_snp1kg_grch38.chr19.gbwt -r nygc_snp1kg_grch38.chr19.gbwt.gg -d nygc_snp1kg_grch38.chr19.dist -s nygc_snp1kg_grch38.chr19.segregated-regions.data.txt -o nygc_snp1kg_grch38.chr19.segregated-regions.gbwt nygc_snp1kg_grch38.chr19.pg > nygc_snp1kg_grch38.chr19.segregated-regions.pg

#create the gbwt graph:
# vg gbwt -g nygc_snp1kg_grch38.chr19.segregated-regions.gbwt.gg -x nygc_snp1kg_grch38.chr19.segregated-regions.pg nygc_snp1kg_grch38.chr19.segregated-regions.gbwt

#normalize the segregated-regions graph.
nice time vg normalize --run_tests -t 20 -g nygc_snp1kg_grch38.chr19.segregated-regions.gbwt -r nygc_snp1kg_grch38.chr19.segregated-regions.gbwt.gg -d nygc_snp1kg_grch38.chr19.dist -S nygc_snp1kg_grch38.chr19.segregated-regions.data.txt -o nygc_snp1kg_grch38.chr19.segregated-regions.gbwt nygc_snp1kg_grch38.chr19.segregated-regions.pg > nygc_snp1kg_grch38.chr19.desegregated.normalized.pg

####scratch/junk:
#scp for chr19 files from mustard to local.
# nygc_snp1kg_grch38.chr19.gbwt -r nygc_snp1kg_grch38.chr19.gbwt.gg -d nygc_snp1kg_grch38.chr19.dist -S nygc_snp1kg_grch38.chr19.segregated-regions.data.txt -o nygc_snp1kg_grch38.chr19.segregated-regions.gbwt nygc_snp1kg_grch38.chr19.segregated-regions.pg > nygc_snp1kg_grch38.chr19.desegregated.normalized.pg


# scp rrounthw@mustard:/private/groups/patenlab/rrounthw/nygc/chr19/nygc_snp1kg_grch38.chr19.* .