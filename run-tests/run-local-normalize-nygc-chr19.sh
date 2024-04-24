#!/bin/bash
set -ex
set -o pipefail
cd ~/paten_lab/vg-team/vg/
. ./source_me.sh && make -j 20 


cd ~/paten_lab/vg-team/vg/robin-graphs/nygc-chr19

#variables for the core normalize pipeline:
UNNORM_BASE=nygc.chr19
SEGREGATED_BASE=${UNNORM_BASE}.segregated-regions
NORM_BASE=${SEGREGATED_BASE}.desegregated.normalized

#for various tests:
SKIP_DESEGREGATE_BASE=${SEGREGATED_BASE}.skip-desegregated.normalized
NORMALIZE_FIRST_3K_SNARLS_BASE=${SEGREGATED_BASE}.only-3k-norm.normalized


#------------
#really the below two commands take too long to run locally. 
#Should be ran on mustard.
# make the segregated graph. #NOTE: this should probably be ran exclusively on mustard, since it takes a while.
# vg normalize -g ${UNNORM_BASE}.combined.gbwt -r ${UNNORM_BASE}.combined.gbwt.gg -d ${UNNORM_BASE}.dist -o ${SEGREGATED_BASE}.combined.gbwt -t 14 --output_segregate_regions_only_file ${SEGREGATED_BASE}.data.txt ${UNNORM_BASE}.pg > ${SEGREGATED_BASE}.pg
vg normalize -g ${UNNORM_BASE}.combined.gbwt -r ${UNNORM_BASE}.combined.gbwt.gg -d ${UNNORM_BASE}.dist -o ${SEGREGATED_BASE}.combined.debug.gbwt -t 14 --output_segregate_regions_only_file ${SEGREGATED_BASE}.data.txt ${UNNORM_BASE}.pg > ${SEGREGATED_BASE}.debug.pg 2> ${SEGREGATED_BASE}.debug.pg.stderr.txt

# full-chr19 normalize and desegregate. 
# vg normalize -t 12 -T 8 -G ${UNNORM_BASE}.combined.gbwt -R ${UNNORM_BASE}.combined.gbwt.gg -g ${SEGREGATED_BASE}.combined.gbwt -r ${SEGREGATED_BASE}.combined.gbwt.gg -d ${SEGREGATED_BASE}.dist -o ${NORM_BASE}.combined.gbwt -t 14 --input_segregate_regions_only_file ${SEGREGATED_BASE}.data.txt ${SEGREGATED_BASE}.pg > ${NORM_BASE}.pg #2> ${NORM_BASE}.pg.stderr.txt

#------------
# #faster versions of normalize, for testing various things:
# # skip desegregation, since that takes too long for full-chr19 job.
# vg normalize --skip_desegregate -g ${SEGREGATED_BASE}.combined.gbwt -r ${SEGREGATED_BASE}.combined.gbwt.gg -d ${SEGREGATED_BASE}.dist -o ${SKIP_DESEGREGATE_BASE}.combined.gbwt -t 14 --input_segregate_regions_only_file ${SEGREGATED_BASE}.data.txt ${SEGREGATED_BASE}.pg > ${SKIP_DESEGREGATE_BASE}.pg


# # run the normalized graph on a subset of the chr19 graph (e.g. first 3k snarls). 
# #todo: make the option for this to be possible. Should be integrated with "fill_custom_split_normalize_regions" option.
# vg normalize -g ${SEGREGATED_BASE}.combined.gbwt -r ${SEGREGATED_BASE}.combined.gbwt.gg -d ${SEGREGATED_BASE}.dist -o ${NORMALIZE_FIRST_3K_SNARLS_BASE}.combined.gbwt -t 14 --input_segregate_regions_only_file ${SEGREGATED_BASE}.data.txt ${SEGREGATED_BASE}.pg > ${NORMALIZE_FIRST_3K_SNARLS_BASE}.pg

