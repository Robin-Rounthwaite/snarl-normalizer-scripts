#!/bin/bash
set -ex
cd /private/groups/patenlab/rrounthw/vg/
. ./source_me.sh
cd /private/groups/patenlab/rrounthw/nygc/chr19/chr19-from-scratch

###Replacing unnorm and norm graphs' "chr19" path name with GRCH38#0#chr19 to make the resulting gam mapping comparable to the one from hg002.
UNNORM_BASE=nygc.chr19
NORM_BASE=${UNNORM_BASE}.desegregated.normalized
# vg convert -f nygc.chr19.pg > nygc.chr19.gfa
sed 's/chr19/GRCH38#0#chr19/g' ${UNNORM_BASE}.gfa >${UNNORM_BASE}.pansn.gfa
vg convert -p ${UNNORM_BASE}.pansn.gfa > ${UNNORM_BASE}.pansn.pg

vg convert -f ${NORM_BASE}.pg > ${NORM_BASE}.gfa
sed 's/chr19/GRCH38#0#chr19/g' ${NORM_BASE}.gfa >${NORM_BASE}.pansn.gfa
vg convert -p ${NORM_BASE}.pansn.gfa > ${NORM_BASE}.pansn.pg




###failed attempt to create no-ref-pansn because it would require reformatting a gfa walk to a path, which is mildly complicated.

# cd /private/groups/patenlab/rrounthw/vg/
# . ./source_me.sh
# cd /private/groups/patenlab/rrounthw/nygc/chr19/sim-hg002-reads/chr19-hg002-graph

# vg convert -f chr19-hg002.xg > chr19-hg002.gfa

# sed 's/GRCH38#0#chr19/chr19/g' chr19-hg002.gfa >chr19-hg002.no-ref-pansn.gfa
# # GRCH38#0#chr19
# vg convert -p chr19-hg002.no-ref-pansn.gfa > chr19-hg002.no-ref-pansn.pg

# nice time vg sim --num-reads 1000000 --frag-len 500 --read-length 100 --random-seed 9999 --progress -x chr19-hg002.no-ref-pansn.pg --align-out -P HG002#1#JAHKSE010000050.1#0 -P HG002#1#JAHKSE010000058.1#0 -P HG002#1#JAHKSE010000061.1#0 -P hg002#2#JAHKSD010000042.1#0 -P hg002#2#JAHKSD010000425.1#0 -P hg002#2#JAHKSD010000195.1#0 -P hg002#2#JAHKSD010000079.1#0 -P hg002#2#JAHKSD010000133.1#0 -P HG002#1#JAHKSE010000139.1#0 -P HG002#1#JAHKSE010000056.1#0 -P hg002#2#JAHKSD010000015.1#0 >/private/groups/patenlab/rrounthw/nygc/chr19/sim-hg002-reads/sim-1m-reads.chr19-hg002.no-ref-pansn.gam

 

# GRCH38#0#chr19
