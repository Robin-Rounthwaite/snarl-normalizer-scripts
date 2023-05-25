#first, source_me at vg

#experiment that has weird node ids. I don't know where I got these node ids, but I think they're wrong.
# LEFTMOST_NODE=33590407
# RIGHTMOST_NODE=33591508

LEFTMOST_NODE=33590400
RIGHTMOST_NODE=33590407

#Changing these variables will change whether you're looking at the names of the reads 
# mapped to the region in the unnorm graph or the norm graph. (You will extract the chosen
# reads from both unnorm and norm either way.)
GAM_BASE=hg38-hsvlr_srdedup17_aug.chr6.mpmap-aln.sorted
GRAPH=hg38-hsvlr_srdedup17_aug.chr6.xg

#These are the files from which reads will be extracted from (based on above read names). Should be both norm and unnorm:
UNNORM_SAM=hg38-hsvlr_srdedup17_aug.chr6.normalized.mpmap-aln.chr6-surject.sam
NORM_SAM=hg38-hsvlr_srdedup17_aug.chr6.normalized.mpmap-aln.chr6-surject.sam

# extracts the gam for just the reads of interest.
vg find -x ${GRAPH} -o ${LEFTMOST_NODE}:${RIGHTMOST_NODE} -l ${GAM_BASE}.gam > ${GAM_BASE}.find-nodes-${LEFTMOST_NODE}-${RIGHTMOST_NODE}.gam
vg view -aj ${GAM_BASE}.find-nodes-${LEFTMOST_NODE}-${RIGHTMOST_NODE}.gam | jq -r '.name' > ${GAM_BASE}.find-nodes-${LEFTMOST_NODE}-${RIGHTMOST_NODE}.gam.read-names.txt && echo "done with view" &&
grep -f ${GAM_BASE}.find-nodes-${LEFTMOST_NODE}-${RIGHTMOST_NODE}.gam.read-names.txt ${UNNORM_SAM} > ${GAM_BASE}.find-nodes-${LEFTMOST_NODE}-${RIGHTMOST_NODE}.gam.reads-extracted-from-unnorm-surjected.sam && echo "done with unnorm grep" &&
grep -f ${GAM_BASE}.find-nodes-${LEFTMOST_NODE}-${RIGHTMOST_NODE}.gam.read-names.txt ${NORM_SAM} > ${GAM_BASE}.find-nodes-${LEFTMOST_NODE}-${RIGHTMOST_NODE}.gam.reads-extracted-from-norm-surjected.sam && echo "done with norm grep"


# grep -f ${GAM_BASE}.find-nodes-${LEFTMOST_NODE}-${RIGHTMOST_NODE}.gam.read-names.txt ${SAM} > hg38-hsvlr_srdedup17_aug.chr6.normalized.mpmap-aln.chr6-surject.reads-mapped-between-nodes-${LEFTMOST_NODE}-${RIGHTMOST_NODE}-in-unnorm.sam
