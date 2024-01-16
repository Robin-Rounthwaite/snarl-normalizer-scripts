THREADS=14
GRAPH=hg38-hsvlr_srdedup17_aug.normalized
READS=HG002-hg38-hsvlr_srdedup17_aug.giraffe29k11w32N_fast.gam

nice vg gbwt -g ${GRAPH}.gg -x ${GRAPH}.xg ${GRAPH}.gbwt 

nice vg minimizer -k 29 -w 11 -t ${THREADS} ${GRAPH}.gg -o ${GRAPH}.k29.w11.min

nice vg index -t ${THREADS} -j ${GRAPH}.dist ${GRAPH}.xg

nice vg giraffe -b fast -i -t ${THREADS} -m ${GRAPH}.k29.w11.min -d ${GRAPH}.dist -G ${READS} -x ${GRAPH}.xg -g ${GRAPH}.gg -H ${GRAPH}.gbwt >${GRAPH}.robin-giraffe-29k11w32N-fast.gam

nice vg augment -t ${THREADS} ${GRAPH}.pg ${GRAPH}.robin-giraffe-29k11w32N-fast.gam > ${GRAPH}.aug.pg

######
THREADS=14
GRAPH=hg38-hsvlr_srdedup17_aug
READS=HG002-hg38-hsvlr_srdedup17_aug.giraffe29k11w32N_fast.gam

nice vg giraffe -i -t ${THREADS} -m ${GRAPH}.k29.w11.N32.min -d ${GRAPH}.dist -G ${READS} -x ${GRAPH}.xg -g ${GRAPH}.N32.gg -H ${GRAPH}.N32.gbwt >${GRAPH}.robin-giraffe-29k11w32N-fast.gam

nice vg augment -t ${THREADS} ${GRAPH}.pg ${GRAPH}.robin-giraffe-29k11w32N-fast.gam > ${GRAPH}.aug.pg



# vg surject -x graph.xg -t ${THREADS} -p 