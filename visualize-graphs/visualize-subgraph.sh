#To Graph Visualization based on highly specific handle extraction: (#note, add vg mod -Ou to merge consecutive nodes) 
# Old way: 
vg normalize -D leftmost_node:rightmost_node graph.vg > region_nodes.txt 
vg find -N region_nodes.txt -x graph.xg | vg mod -Ou - | vg view -dp - | dot -Tsvg -o subgraph.svg 
# New way: (only works if ids are consectutively numbered)
vg find -r first_node:last_node -x graph.any-format.pg | vg view -dp - | dot -Tsvg -o subgraph.svg 

## to just get a subgraph based on a node + context:
vg find -n node_id -c context -x graph.any-format.pg | vg view -dp - | dot -Tsvg -o subgraph.svg 


#Feb 14 2024 - happy Valentine's day! (using node + context method)
cd ~/paten_lab/vg-team/vg/robin-graphs/nygc-chr19/
UNNORM_BASE=nygc.chr19 && SEGREGATED_BASE=${UNNORM_BASE}.segregated-regions
CONTEXT=10
NODE_ID=4834600
vg find -n ${NODE_ID} -c ${CONTEXT} -x ${SEGREGATED_BASE}.pg| vg view -dp - | dot -Tsvg -o ${SEGREGATED_BASE}.c-${CONTEXT}.n-${NODE_ID}.svg 
chromium-browser ${SEGREGATED_BASE}.c-${CONTEXT}.n-${NODE_ID}.svg &

#Feb 21 2024 (using "Old Way," since the node ids aren't necessarily consecutively ordered in norm.)
#note: used "vg normalize -N ... | vg mod -Ou - | vg view..." which had vg mod orienting the nodes forward and unchopping them. But I've removed that for better viewing of the actual graph I'm dealing with. 
cd ~/paten_lab/vg-team/vg/
. ./source_me.sh && make -j 20
cd ~/paten_lab/vg-team/vg/robin-graphs/nygc-chr19/
UNNORM_BASE=nygc.chr19
NORM_BASE=${UNNORM_BASE}.desegregated.normalized

# some visualizations before Mar 20 2024:
# LEFT_NODE_ID=2008817
# RIGHT_NODE_ID=2008887
# LEFT_NODE_ID=4458402
# RIGHT_NODE_ID=4458524
#Mar 20 2024:
LEFT_NODE_ID=170311
RIGHT_NODE_ID=170313
CONTEXT=10


UNNORM_SUBGRAPH_BASE=${UNNORM_BASE}.${LEFT_NODE_ID}-${RIGHT_NODE_ID}
vg normalize -D ${LEFT_NODE_ID}:${RIGHT_NODE_ID} ${UNNORM_BASE}.pg > ${UNNORM_SUBGRAPH_BASE}.region_nodes.txt 
vg find -c ${CONTEXT} -N ${UNNORM_SUBGRAPH_BASE}.region_nodes.txt -x ${UNNORM_BASE}.pg | vg view -dp - | dot -Tsvg -o ${UNNORM_SUBGRAPH_BASE}.svg 
chromium-browser ${UNNORM_SUBGRAPH_BASE}.svg &

NORM_SUBGRAPH_BASE=${NORM_BASE}.${LEFT_NODE_ID}-${RIGHT_NODE_ID}
vg normalize -D ${LEFT_NODE_ID}:${RIGHT_NODE_ID} ${NORM_BASE}.pg > ${NORM_SUBGRAPH_BASE}.region_nodes.txt 
vg find -c ${CONTEXT} -N ${NORM_SUBGRAPH_BASE}.region_nodes.txt -x ${NORM_BASE}.pg | vg view -dp - | dot -Tsvg -o ${NORM_SUBGRAPH_BASE}.svg 
chromium-browser ${NORM_SUBGRAPH_BASE}.svg &


#Mar 20 2024: (Old way, unnorm and segregated-regions-graph)
cd ~/paten_lab/vg-team/vg/
. ./source_me.sh && make -j 20
cd ~/paten_lab/vg-team/vg/robin-graphs/nygc-chr19/
UNNORM_BASE=nygc.chr19
NORM_BASE=${UNNORM_BASE}.segregated-regions

LEFT_NODE_ID=170311
RIGHT_NODE_ID=170313
CONTEXT=10

UNNORM_SUBGRAPH_BASE=${UNNORM_BASE}.${LEFT_NODE_ID}-${RIGHT_NODE_ID}
vg normalize -D ${LEFT_NODE_ID}:${RIGHT_NODE_ID} ${UNNORM_BASE}.pg > ${UNNORM_SUBGRAPH_BASE}.region_nodes.txt 
vg find -c ${CONTEXT} -N ${UNNORM_SUBGRAPH_BASE}.region_nodes.txt -x ${UNNORM_BASE}.pg | vg view -dp - | dot -Tsvg -o ${UNNORM_SUBGRAPH_BASE}.svg 
chromium-browser ${UNNORM_SUBGRAPH_BASE}.svg &

NORM_SUBGRAPH_BASE=${NORM_BASE}.${LEFT_NODE_ID}-${RIGHT_NODE_ID}
vg normalize -D ${LEFT_NODE_ID}:${RIGHT_NODE_ID} ${NORM_BASE}.pg > ${NORM_SUBGRAPH_BASE}.region_nodes.txt 
vg find -c ${CONTEXT} -N ${NORM_SUBGRAPH_BASE}.region_nodes.txt -x ${NORM_BASE}.pg | vg view -dp - | dot -Tsvg -o ${NORM_SUBGRAPH_BASE}.svg 
chromium-browser ${NORM_SUBGRAPH_BASE}.svg &


#april 19, just unnorm:
cd ~/paten_lab/vg-team/vg/
. ./source_me.sh && make -j 20
cd ~/paten_lab/vg-team/vg/robin-graphs/nygc-chr19/
UNNORM_BASE=nygc.chr19
NORM_BASE=${UNNORM_BASE}.desegregated.normalized

LEFT_NODE_ID=2700
RIGHT_NODE_ID=2770
CONTEXT=10

UNNORM_SUBGRAPH_BASE=${UNNORM_BASE}.${LEFT_NODE_ID}-${RIGHT_NODE_ID}
vg normalize -D ${LEFT_NODE_ID}:${RIGHT_NODE_ID} ${UNNORM_BASE}.pg > ${UNNORM_SUBGRAPH_BASE}.region_nodes.txt 
vg find -c ${CONTEXT} -N ${UNNORM_SUBGRAPH_BASE}.region_nodes.txt -x ${UNNORM_BASE}.pg | vg view -dp - | dot -Tsvg -o ${UNNORM_SUBGRAPH_BASE}.svg 
chromium-browser ${UNNORM_SUBGRAPH_BASE}.svg &


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

UNNORM_SUBGRAPH_BASE=${OUTPUT_DIR}/${UNNORM_BASE}.${META}.focus-${FOCAL_NODE}-context-${CONTEXT}
vg find -n ${FOCAL_NODE} -c ${CONTEXT} -x ${UNNORM_BASE}.pg | vg view -dp - | dot -Tsvg -o ${UNNORM_SUBGRAPH_BASE}.svg
chromium-browser ${UNNORM_SUBGRAPH_BASE}.svg &

NORM_SUBGRAPH_BASE=${OUTPUT_DIR}/${NORM_BASE}.${META}.focus-${FOCAL_NODE}-context-${CONTEXT}
vg find -n ${FOCAL_NODE} -c ${CONTEXT} -x ${NORM_BASE}.pg | vg view -dp - | dot -Tsvg -o ${NORM_SUBGRAPH_BASE}.svg
chromium-browser ${NORM_SUBGRAPH_BASE}.svg &

#May 13, based just on node + context, both unnorm and norm:
cd ~/paten_lab/vg-team/vg/
. ./source_me.sh && make -j 20
cd ~/paten_lab/vg-team/vg/robin-graphs/nygc-chr19/
OUTPUT_DIR=~/paten_lab/vg-team/vg/robin-graphs/nygc-chr19/contrast-gams/visualize-mapping-changes/2024-05-07.0.dropping_mapq.dropping_accuracy.shuf_3.json
UNNORM_BASE=nygc.chr19
NORM_BASE=${UNNORM_BASE}.desegregated.normalized-directly-from-unnorm.grch38-ref.pansn

FOCAL_NODE=1495501
CONTEXT=10
META=dropping-mapq-accuracy.unnormalized-mapping-correct-location

UNNORM_SUBGRAPH_BASE=${OUTPUT_DIR}/${UNNORM_BASE}.${META}.focus-${FOCAL_NODE}-context-${CONTEXT}
vg find -n ${FOCAL_NODE} -c ${CONTEXT} -x ${UNNORM_BASE}.pg | vg view -dp - | dot -Tsvg -o ${UNNORM_SUBGRAPH_BASE}.svg
chromium-browser ${UNNORM_SUBGRAPH_BASE}.svg &

NORM_SUBGRAPH_BASE=${OUTPUT_DIR}/${NORM_BASE}.${META}.focus-${FOCAL_NODE}-context-${CONTEXT}
vg find -n ${FOCAL_NODE} -c ${CONTEXT} -x ${NORM_BASE}.pg | vg view -dp - | dot -Tsvg -o ${NORM_SUBGRAPH_BASE}.svg
chromium-browser ${NORM_SUBGRAPH_BASE}.svg &

#May 25 2024: (Old way, unnorm to match the existing viz of norm at..)
#(file:///home/robin/paten_lab/vg-team/vg/robin-graphs/nygc-chr19/contrast-gams/dropping_mapq/dropping_accuracy/0.14e59ec43889c5e5.normalized.primary.read-pair-1.mapping-quality-NA.correctly-mapped-NA.reference-position-NA-NA.node-start-end-7147516-7147541.svg)
cd ~/paten_lab/vg-team/vg/
. ./source_me.sh && make -j 20
cd ~/paten_lab/vg-team/vg/robin-graphs/nygc-chr19/
UNNORM_BASE=nygc.chr19

LEFT_NODE_ID=773002
RIGHT_NODE_ID=773075
CONTEXT=10
UNNORM_SUBGRAPH_BASE=0.14e59ec43889c5e5.unnormalized-c-${CONTEXT}-view-of.normalized.primary.read-pair-1.mapping-quality-NA.correctly-mapped-NA.reference-position-NA-NA.node-start-end-7147516-7147541.svg
# UNNORM_SUBGRAPH_BASE=${UNNORM_BASE}.${LEFT_NODE_ID}-${RIGHT_NODE_ID}
vg normalize -D ${LEFT_NODE_ID}:${RIGHT_NODE_ID} ${UNNORM_BASE}.pg > ${UNNORM_SUBGRAPH_BASE}.region_nodes.txt 
vg find -c ${CONTEXT} -N ${UNNORM_SUBGRAPH_BASE}.region_nodes.txt -x ${UNNORM_BASE}.pg | vg view -dp - | dot -Tsvg -o ${UNNORM_SUBGRAPH_BASE}.svg 
chromium-browser ${UNNORM_SUBGRAPH_BASE}.svg &

LEFT_NODE_ID=7147516
RIGHT_NODE_ID=7147541
NORM_BASE=nygc.chr19.desegregated.normalized-directly-from-unnorm.grch38-ref.pansn
CONTEXT=100
NORM_SUBGRAPH_BASE=0.14e59ec43889c5e5.normalized-c-${CONTEXT}-view-of.normalized.primary.read-pair-1.mapping-quality-NA.correctly-mapped-NA.reference-position-NA-NA.node-start-end-7147516-7147541.svg
vg normalize -D ${LEFT_NODE_ID}:${RIGHT_NODE_ID} ${NORM_BASE}.pg > ${NORM_SUBGRAPH_BASE}.region_nodes.txt 
vg find -c ${CONTEXT} -N ${NORM_SUBGRAPH_BASE}.region_nodes.txt -x ${NORM_BASE}.pg | vg view -dp - | dot -Tsvg -o ${NORM_SUBGRAPH_BASE}.svg 
chromium-browser ${NORM_SUBGRAPH_BASE}.svg &



#May 27 2024: (Old way, unnorm to match the existing viz of norm at..)
cd ~/paten_lab/vg-team/vg/
. ./source_me.sh && make -j 20
cd ~/paten_lab/vg-team/vg/robin-graphs/nygc-chr19/

LEFT_NODE_ID=3633719
RIGHT_NODE_ID=3633726
NORM_BASE=nygc.chr19.desegregated.normalized-directly-from-unnorm.grch38-ref.pansn.norm-single-region.3633719-3633726
CONTEXT=10
NORM_SUBGRAPH_BASE=0.14e59ec43889c5e5.normalized-c-${CONTEXT}-view-of.normalized.primary.read-pair-1.mapping-quality-NA.correctly-mapped-NA.reference-position-NA-NA.node-start-end-7147516-7147541.svg
vg normalize -D ${LEFT_NODE_ID}:${RIGHT_NODE_ID} ${NORM_BASE}.pg > ${NORM_SUBGRAPH_BASE}.region_nodes.txt 
vg find -c ${CONTEXT} -N ${NORM_SUBGRAPH_BASE}.region_nodes.txt -x ${NORM_BASE}.pg | vg view -dp - | dot -Tsvg -o ${NORM_SUBGRAPH_BASE}.svg 
chromium-browser ${NORM_SUBGRAPH_BASE}.svg &
