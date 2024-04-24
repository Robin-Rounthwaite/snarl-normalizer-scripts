#!/bin/bash
set -ex
set -o pipefail
cd /private/groups/patenlab/rrounthw/vg
# cd /private/groups/patenlab/rrounthw/vg-2/vg/
git checkout master
git pull
# git checkout robin-preserve-segregated-node-to-parent-in-segregated-regions-file #note: sometimes gotta checkout master before checking out other branches. When already on the right branch, both the master line and this line can be commented out right to prevent unnecessary recompiling.
# git pull
. ./source_me.sh && make -j 20
cd /private/groups/patenlab/rrounthw/nygc/chr19/chr19-from-scratch

#variables for the core normalize pipeline:
UNNORM_BASE=nygc.chr19
SEGREGATED_BASE=${UNNORM_BASE}.segregated-regions
NORM_BASE=${SEGREGATED_BASE}.desegregated.normalized.debug

# #for various tests:
# SKIP_DESEGREGATE_BASE=${SEGREGATED_BASE}.skip-desegregated.normalized
# NORMALIZE_FIRST_3K_SNARLS_BASE=${SEGREGATED_BASE}.only-3k-norm.normalized


#------------
#really the below two commands take too long to run locally. 
#Should be ran on mustard.
# make the segregated graph. #NOTE: this should probably be ran exclusively on mustard, since it takes a while.
vg normalize -t 20 -T 10 -g ${UNNORM_BASE}.combined.gbwt -r ${UNNORM_BASE}.combined.gbwt.gg -d ${UNNORM_BASE}.dist -o ${SEGREGATED_BASE}.combined.gbwt -t 14 --output_segregate_regions_only_file ${SEGREGATED_BASE}.data.txt ${UNNORM_BASE}.pg > ${SEGREGATED_BASE}.pg 2>${SEGREGATED_BASE}.pg.stderr.txt

# full-chr19 normalize and desegregate. 
nice time -v vg normalize -t 20 -T 10 -G ${UNNORM_BASE}.combined.gbwt -R ${UNNORM_BASE}.combined.gbwt.gg -g ${SEGREGATED_BASE}.combined.gbwt -r ${SEGREGATED_BASE}.combined.gbwt.gg -d ${SEGREGATED_BASE}.dist -o ${NORM_BASE}.combined.gbwt -t 14 --input_segregate_regions_only_file ${SEGREGATED_BASE}.data.txt ${SEGREGATED_BASE}.pg > ${NORM_BASE}.pg 2>${NORM_BASE}.pg.stderr.txt



#junk:
# vg normalize --skip_desegregate -t 20 -g nygc.chr19.segregated-regions.gbwt -r nygc.chr19.segregated-regions.gbwt.gg -S nygc.chr19.segregated-regions.data.txt nygc.chr19.segregated-regions.pg >nygc.chr19.segregated-regions.normalized.debug-move-paths-undefined.skip-desegregate.pg 2> nygc.chr19.segregated-regions.normalized.debug-move-paths-undefined.skip-desegregate.pg.stderr.txt
