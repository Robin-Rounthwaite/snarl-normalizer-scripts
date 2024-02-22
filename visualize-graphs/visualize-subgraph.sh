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
cd ~/paten_lab/vg-team/vg/robin-graphs/nygc-chr19/
UNNORM_BASE=nygc.chr19
NORM_BASE=${UNNORM_BASE}.desegregated.normalized
CONTEXT=10
LEFT_NODE_ID=2008817
RIGHT_NODE_ID=2008887
UNNORM_SUBGRAPH_BASE=${UNNORM_BASE}.${LEFT_NODE_ID}-${RIGHT_NODE_ID}
NORM_SUBGRAPH_BASE=${NORM_BASE}.${LEFT_NODE_ID}-${RIGHT_NODE_ID}
vg normalize -D ${LEFT_NODE_ID}:${RIGHT_NODE_ID} ${NORM_BASE}.pg > ${NORM_SUBGRAPH_BASE}.region_nodes.txt 
vg find -N ${NORM_SUBGRAPH_BASE}.region_nodes.txt -x ${NORM_BASE}.pg | vg mod -Ou - | vg view -dp - | dot -Tsvg -o ${NORM_SUBGRAPH_BASE}.svg 
chromium-browser ${NORM_SUBGRAPH_BASE}.svg &

vg normalize -D ${LEFT_NODE_ID}:${RIGHT_NODE_ID} ${UNNORM_BASE}.pg > ${UNNORM_SUBGRAPH_BASE}.region_nodes.txt 
vg find -N ${UNNORM_SUBGRAPH_BASE}.region_nodes.txt -x ${UNNORM_BASE}.pg | vg mod -Ou - | vg view -dp - | dot -Tsvg -o ${UNNORM_SUBGRAPH_BASE}.svg 
chromium-browser ${UNNORM_SUBGRAPH_BASE}.svg &