#!/bin/bash
set -ex
cd ~/paten_lab/vg-team/vg/
. ./source_me.sh && make -j 20 

# Goal of this test is to export gbwt update data to a file and make sure it looks 
# reasonable.

cd ~/paten_lab/vg-team/vg/test/tiny/custom-tiny/

UNNORM_BASE=tiny-edited.single-base-shared-snarl-border
NORM_BASE=${UNNORM_BASE}.normalized

#testing -E (debug_export_gbwt_desegregate_data)
vg normalize -E tiny-edited.single-base-shared-snarl-border.test-export-gbwt-desegregation --max_region_gap 0 -t 20 -T 8 -g ${UNNORM_BASE}.gbwt -r ${UNNORM_BASE}.gbwt.gg -d ${UNNORM_BASE}.dist --run_tests ${UNNORM_BASE}.pg 

# testing the code snippet that reads the exported data:
# vg normalize -D 1:1 -g ${UNNORM_BASE}.gbwt -r ${UNNORM_BASE}.gbwt.gg -d ${UNNORM_BASE}.dist --run_tests ${UNNORM_BASE}.pg 
