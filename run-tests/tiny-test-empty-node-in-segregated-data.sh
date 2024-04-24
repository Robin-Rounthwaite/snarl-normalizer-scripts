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

##testing the empty node in segregation:
#with max region gap as 0, we'll normalize each snarl separately. Thus creating the empty
#node between the first two snarls.
#pg version:
vg normalize --max_region_gap 0 -t 1 -g ${UNNORM_BASE}.gbwt -r ${UNNORM_BASE}.gbwt.gg -d ${UNNORM_BASE}.dist -o ${NORM_BASE}.gbwt --run_tests ${UNNORM_BASE}.pg > ${NORM_BASE}.pg
ls -alt ${NORM_BASE}.pg

#visualize the unnormalized graph:
vg view -dp ${UNNORM_BASE}.pg | dot -Tsvg -o ${UNNORM_BASE}.svg 
chromium-browser ${UNNORM_BASE}.svg &

sleep 1

#visualize the normalized graph:
vg view -dp ${NORM_BASE}.pg | dot -Tsvg -o ${NORM_BASE}.svg 
chromium-browser ${NORM_BASE}.svg &

#to check if the gbwt is valid, re-normalize the normalized graph and see if the gbwt still matches up.
NORM_NORM_BASE=${NORM_BASE}.normalized
# vg gbwt -g ${NORM_BASE}.gbwt.gg -x ${NORM_BASE}.pg ${NORM_BASE}.gbwt
vg index -j ${NORM_BASE}.dist ${NORM_BASE}.pg
vg normalize --max_region_gap 0 -t 1 -g ${NORM_BASE}.gbwt -r ${NORM_BASE}.gbwt.gg -d ${NORM_BASE}.dist -o ${NORM_NORM_BASE}.gbwt --run_tests ${NORM_BASE}.pg > ${NORM_NORM_BASE}.pg





# junk (miscellaneous commands used while debugging):
#vg version:
# vg normalize --max_region_gap 0 -g ${UNNORM_BASE}.gbwt -r ${UNNORM_BASE}.gbwt.gg -d ${UNNORM_BASE}.dist -o ${NORM_BASE}.gbwt --run_tests ${UNNORM_BASE}.vg > ${NORM_BASE}.vg

##pg testing -T
# vg normalize --max_region_gap 0 -t 20 -T 8 -g ${UNNORM_BASE}.gbwt -r ${UNNORM_BASE}.gbwt.gg -d ${UNNORM_BASE}.dist -o ${NORM_BASE}.gbwt --run_tests ${UNNORM_BASE}.pg > ${NORM_BASE}.pg
