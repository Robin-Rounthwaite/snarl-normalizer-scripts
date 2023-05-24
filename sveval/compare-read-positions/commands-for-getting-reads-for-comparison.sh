LEFTMOST_NODE=33590407
RIGHTMOST_NODE=33591508
#These determine whether I'm extracting reads from norm or unnorm:
MAPPING_EXPERIMENT=norm
SAM=hg38-hsvlr_srdedup17_aug.chr6.normalized.mpmap-aln.chr6-surject.sam

#There's reasonable odds you don't want to change this, if you want the reads you're looking at to stay the same in the graph before/after normalization.
GAM_BASE=hg38-hsvlr_srdedup17_aug.chr6.mpmap-aln.sorted
GRAPH=hg38-hsvlr_srdedup17_aug.chr6.xg


vg find -x ${GRAPH} -o ${LEFTMOST_NODE}:${RIGHTMOST_NODE} -l ${GAM_BASE}.gam > ${GAM_BASE}.find-nodes-${LEFTMOST_NODE}-${RIGHTMOST_NODE}.gam
grep -f ${GAM_BASE}.find-nodes-${LEFTMOST_NODE}-${RIGHTMOST_NODE}.gam.read-names.txt ${SAM} > ${GAM_BASE}.find-nodes-${LEFTMOST_NODE}-${RIGHTMOST_NODE}.gam.reads-extracted-from-${MAPPING_EXPERIMENT}-surjected-sam.sam
# grep -f ${GAM_BASE}.find-nodes-${LEFTMOST_NODE}-${RIGHTMOST_NODE}.gam.read-names.txt ${SAM} > hg38-hsvlr_srdedup17_aug.chr6.normalized.mpmap-aln.chr6-surject.reads-mapped-between-nodes-${LEFTMOST_NODE}-${RIGHTMOST_NODE}-in-unnorm.sam