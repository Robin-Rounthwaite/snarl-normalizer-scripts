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

# #### preparation for normalize

# nice time vg gbwt --index-paths -x nygc_snp1kg_grch38.chr19.pg -o nygc_snp1kg_grch38.chr19.gbwt -g nygc_snp1kg_grch38.chr19.gbwt.gg

# #todo: check to see if the gbwt has the reference path chr19 that I want.
# # nice time vg paths -Lx hprc-chm-hg002-aug15.chr21.gbz > hprc-chm-hg002-aug15.chr21.gbz.paths.txt
# nice time vg paths -Lg nygc_snp1kg_grch38.chr19.gbwt > nygc_snp1kg_grch38.chr19.gbwt.paths.txt

# nice time vg index -j nygc_snp1kg_grch38.chr19.dist nygc_snp1kg_grch38.chr19.pg

# #todo: make the .gbwt if I need it (incl. the ref path)
# nice time vg minimizer -g nygc_snp1kg_grch38.chr19.gbwt -d nygc_snp1kg_grch38.chr19.dist -o nygc_snp1kg_grch38.chr19.min nygc_snp1kg_grch38.chr19.pg

#### normalize

#make the segregated-regions graph.
# nice time vg normalize -g nygc_snp1kg_grch38.chr19.gbwt -r nygc_snp1kg_grch38.chr19.gbwt.gg -d nygc_snp1kg_grch38.chr19.dist -s nygc_snp1kg_grch38.chr19.segregated-regions.data.txt -o nygc_snp1kg_grch38.chr19.segregated-regions.gbwt nygc_snp1kg_grch38.chr19.pg > nygc_snp1kg_grch38.chr19.segregated-regions.pg

#normalize the segregated-regions graph.
nice time vg normalize --run_tests -t 20 -g nygc_snp1kg_grch38.chr19.gbwt -r nygc_snp1kg_grch38.chr19.gbwt.gg -d nygc_snp1kg_grch38.chr19.dist -S nygc_snp1kg_grch38.chr19.segregated-regions.data.txt -o nygc_snp1kg_grch38.chr19.segregated-regions.gbwt nygc_snp1kg_grch38.chr19.segregated-regions.pg > nygc_snp1kg_grch38.chr19.desegregated.normalized.pg

#### simulate reads from hg002 version of the graph.


#### mapping experiment.

