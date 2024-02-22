#!/bin/bash
set -ex
cd ~/paten_lab/vg-team/vg/
. ./source_me.sh && make -j 20 

#goal of this test is to run full normalize on an adapted tiny test that includes a shared
#single-base node between two snarls. That way the segregate-regions process will create
#an empty node and I can see if there's a problem. 
#Note: I want to make this be on .pg, ince I think there might be a problem there.


cd ~/paten_lab/vg-team/vg/test/tiny/custom-tiny/

UNNORM_BASE=tiny-edited.single-base-shared-snarl-border
NORM_BASE=${UNNORM_BASE}.normalized

#with max region gap as 0, we'll normalize each snarl separately. Thus creating the empty
#node between the first two snarls.
#pg version:
# vg normalize --max_region_gap 0 -g ${UNNORM_BASE}.gbwt -r ${UNNORM_BASE}.gbwt.gg -d ${UNNORM_BASE}.dist -o ${NORM_BASE}.gbwt --run_tests ${UNNORM_BASE}.pg > ${NORM_BASE}.pg

#vg version:
# vg normalize --max_region_gap 0 -g ${UNNORM_BASE}.gbwt -r ${UNNORM_BASE}.gbwt.gg -d ${UNNORM_BASE}.dist -o ${NORM_BASE}.gbwt --run_tests ${UNNORM_BASE}.vg > ${NORM_BASE}.vg

#pg testing -T
vg normalize --max_region_gap 0 -t 20 -T 8 -g ${UNNORM_BASE}.gbwt -r ${UNNORM_BASE}.gbwt.gg -d ${UNNORM_BASE}.dist -o ${NORM_BASE}.gbwt --run_tests ${UNNORM_BASE}.pg > ${NORM_BASE}.pg

