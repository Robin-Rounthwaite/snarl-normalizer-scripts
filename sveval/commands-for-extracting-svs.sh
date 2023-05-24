#### pipeline for getting dot file of region on courtyard, then porting to local machine for visualizing on chromium-browser.
## This set of commands is for getting a visualization based on chromosome position.

#On courtyard:
cd /public/groups/vg/rrounthw/vg/ && . ./source_me.sh
cd /public/groups/vg/rrounthw/jean-combined-sv-graph/chrom-mapping-experiment/

VARIATION_TYPE=del
GRAPH=hg38-hsvlr_srdedup17_aug.chr6
LENGTH=427
POSITION_START=469200
POSITION_END=470000
CONTEXT=10

vg find -x ${GRAPH}.xg -c ${CONTEXT} -p chr6:${POSITION_START}-${POSITION_END} | vg view -dp - >${GRAPH}.${VARIATION_TYPE}-len-${LENGTH}.${POSITION_START}-${POSITION_END}.context-${CONTEXT}.dot
# vg find -x ${GRAPH}.xg -c 20 -p chr6:${POSITION_START}-${POSITION_END} | vg mod -Ou - | vg view -dp - >${GRAPH}.${VARIATION_TYPE}-len-${LENGTH}.${POSITION_START}-${POSITION_END}.context-${CONTEXT}.dot

#Locally:
cd ~/paten_lab/vg-team/vg/robin-scripts/sveval/view-sv/

VARIATION_TYPE=del
GRAPH=hg38-hsvlr_srdedup17_aug.chr6
LENGTH=427
POSITION_START=469200
POSITION_END=470000
CONTEXT=10

scp rrounthw@courtyard.gi.ucsc.edu:/public/groups/vg/rrounthw/jean-combined-sv-graph/chrom-mapping-experiment/${GRAPH}.${VARIATION_TYPE}-len-${LENGTH}.${POSITION_START}-${POSITION_END}.context-${CONTEXT}.dot . && dot ${GRAPH}.${VARIATION_TYPE}-len-${LENGTH}.${POSITION_START}-${POSITION_END}.context-${CONTEXT}.dot -Tsvg -o ${GRAPH}.${VARIATION_TYPE}-len-${LENGTH}.${POSITION_START}-${POSITION_END}.context-${CONTEXT}.svg
chromium-browser ${GRAPH}.${VARIATION_TYPE}-len-${LENGTH}.${POSITION_START}-${POSITION_END}.context-${CONTEXT}.svg &


#########################################################################################


## This set of commands is for getting a visualization based on node id.

GRAPH=hg38-hsvlr_srdedup17_aug.chr6.normalized-2
META=just-snarl
NODE=38916403

vg find -x ${GRAPH}.xg -c 20 -n ${NODE} | vg view -dp - >${GRAPH}.${META}.${NODE}.dot


GRAPH=hg38-hsvlr_srdedup17_aug.chr6.normalized-2
META=just-snarl
NODE=38916403

scp rrounthw@courtyard.gi.ucsc.edu:/public/groups/vg/rrounthw/jean-combined-sv-graph/${GRAPH}.${VARIATION_TYPE}-len-${LENGTH}.${POSITION}.dot . && dot ${GRAPH}.${META}.${NODE}.dot -Tsvg -o ${GRAPH}.${META}.${NODE}.svg 
chromium-browser ${GRAPH}.${META}.${NODE}.svg &
