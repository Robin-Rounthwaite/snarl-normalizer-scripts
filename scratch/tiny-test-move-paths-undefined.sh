#!/bin/bash
set -ex
cd ~/paten_lab/vg-team/vg/
. ./source_me.sh && make -j 20 

# Goal of this test is to figure out what is causing an (undefined behavior?) bug when I
# allow normalize to include paths. (Accomplished! Now this file is just a test to make sure that tiny graphs get normalized while skipping a second update gbwt.)

## eventually try something with tiny graph for an easy quick-to-run test:
cd ~/paten_lab/vg-team/vg/test/tiny/custom-tiny/




#junk:

# running on segregated-graph:
## first run chr19:
# cd ~/paten_lab/vg-team/vg/robin-graphs/nygc-chr19
# vg normalize --skip_desegregate -t 20 -g nygc.chr19.segregated-regions.gbwt -r nygc.chr19.segregated-regions.gbwt.gg -S nygc.chr19.segregated-regions.data.txt nygc.chr19.segregated-regions.pg >nygc.chr19.segregated-regions.normalized.debug-move-paths-undefined.skip-desegregate.pg


#testing out just segregating the graph (to see how it affects paths on nodes adjacent to empty nodes in new split pairs):
# vg normalize --output_segregate_regions_only_file nygc.chr19.test-debug-move-paths-undefined.segregated-regions.data.txt -t 1 -d nygc.chr19.dist -g nygc.chr19.combined.gbwt -r nygc.chr19.combined.gbwt.gg -o nygc.chr19.test-debug-move-paths-undefined.segregated-regions.combined.gbwt nygc.chr19.pg >nygc.chr19.test-debug-move-paths-undefined.segregated-regions.pg
