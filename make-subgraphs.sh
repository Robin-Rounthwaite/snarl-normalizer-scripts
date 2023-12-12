vg find -r 2555912:2555931 -c 4 -x graph.n32.segregated-regions.vg | vg view -dp - | dot -Tsvg -o graph.n32.segregated-regions.2555912-2555931.c4.svg
vg find -r 2624390:2624421 -c 4 -x graph.n32.segregated-regions.vg | vg view -dp - | dot -Tsvg -o graph.n32.segregated-regions.2624390-2624421.c4.svg
vg find -r 1898335:1898346 -c 4 -x graph.n32.segregated-regions.vg | vg view -dp - | dot -Tsvg -o graph.n32.segregated-regions.1898335-1898346.c4.svg
vg find -r 42978513:42978518 -c 4 -x nygc_snp1kg_grch38.pg | vg view -dp - | dot -Tsvg -o nygc_snp1kg_grch38.42978513-42978518.c4.svg
vg find -r 78157365:78157368 -c 4 -x nygc_snp1kg_grch38.pg | vg view -dp - | dot -Tsvg -o nygc_snp1kg_grch38.78157365-78157368.c4.svg
vg find -r 78157365:78157368 -c 4 -x nygc_snp1kg_grch38.pg | vg view -dp - | dot -Tsvg -o nygc_snp1kg_grch38.78157365-78157368.c4.svg

#for the big change in the norm chr21 pg: 996832   997083
# for post-norm:
# file_path=/home/robin/paten_lab/vg-team/vg/robin-graphs/nygc-chr21-segregated-regions/graph.combined.n32.segregated-regions.normalized.nodes-in-996832-997083.txt
cd ~/paten_lab/vg-team/vg/robin-graphs/nygc-chr21-segregated-regions/
LEFTMOST=996832
RIGHTMOST=996832
GRAPH=graph.combined.n32.segregated-regions.normalized.pg

vg normalize -D ${LEFTMOST}:${RIGHTMOST}  >snarl_composite_nodes.${LEFTMOST}-${RIGHTMOST}.txt
vg find -N snarl_composite_nodes.${LEFTMOST}-${RIGHTMOST}.txt -c 4 -x ${graph} | vg view -dp - | dot -Tsvg -o ${GRAPH}.${LEFTMOST}-${RIGHTMOST}.c4.svg
#for pre-norm:
vg find -r ${LEFTMOST}:${RIGHTMOST} -c 4 -x ~/paten_lab/vg-team/vg/robin-graphs/nygc-chr21/graph.pg | vg view -dp - | dot -Tsvg -o graph.${LEFTMOST}-${RIGHTMOST}.c4.svg
