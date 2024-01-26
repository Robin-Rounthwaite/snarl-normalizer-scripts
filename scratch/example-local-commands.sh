#generate a segregated-regions file for testing (using probably the wrong gbwt)
cd ~/paten_lab/vg-team/vg/ && . ./source_me.sh && make -j 20 && cd ~/paten_lab/vg-team/vg/robin-graphs/nygc-chr21 && vg normalize -d graph.dist -g graph.gbwt -r graph.gg -s test.segregated-regions-only.txt graph.pg >test.segregated-regions-only.pg
