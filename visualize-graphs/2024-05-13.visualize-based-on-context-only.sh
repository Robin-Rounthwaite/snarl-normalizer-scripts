set -ex

#May 13, based just on node + context, both unnorm and norm:
cd ~/paten_lab/vg-team/vg/
. ./source_me.sh && make -j 20
cd ~/paten_lab/vg-team/vg/robin-graphs/nygc-chr19/
OUTPUT_DIR=~/paten_lab/vg-team/vg/robin-graphs/nygc-chr19/contrast-gams/visualize-mapping-changes/2024-05-07.0.dropping_mapq.dropping_accuracy.shuf_3.json
UNNORM_BASE=nygc.chr19
NORM_BASE=${UNNORM_BASE}.desegregated.normalized-directly-from-unnorm.grch38-ref.pansn

FOCAL_NODE=1495501
CONTEXT=10
META=dropping-mapq-accuracy.normalized-mapping-incorrect-location

vg find -n ${FOCAL_NODE} -c ${CONTEXT} -x ${NORM_BASE}.pg

# UNNORM_SUBGRAPH_BASE=${OUTPUT_DIR}/${UNNORM_BASE}.${META}.focus-${FOCAL_NODE}-context-${CONTEXT}
# vg find -n ${FOCAL_NODE} -c ${CONTEXT} -x ${UNNORM_BASE}.pg | vg view -dp - | dot -Tsvg -o ${UNNORM_SUBGRAPH_BASE}.svg
# chromium-browser ${UNNORM_SUBGRAPH_BASE}.svg &

NORM_SUBGRAPH_BASE=${OUTPUT_DIR}/${NORM_BASE}.${META}.focus-${FOCAL_NODE}-context-${CONTEXT}
vg find -n ${FOCAL_NODE} -c ${CONTEXT} -x ${NORM_BASE}.pg | vg view -dp - | dot -Tsvg -o ${NORM_SUBGRAPH_BASE}.svg
chromium-browser ${NORM_SUBGRAPH_BASE}.svg &
