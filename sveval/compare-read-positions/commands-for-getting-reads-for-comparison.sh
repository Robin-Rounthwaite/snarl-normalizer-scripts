#first, source_me at vg

#experiment that has weird node ids. I don't know where I got these node ids, but I think they're wrong.
# LEFTMOST_NODE=33590407
# RIGHTMOST_NODE=33591508

# # this is for variant 3.
# # """
# # Here is the first potential variant to investigate! It’s an insertion seen only in the normalized graph.

# # > chr6	515574	515659	86	*	PASS	INS	86	1	AGTCCTAGGA...	228	TRUE	TRUE
# # """
#NOTE: these node ranges were too short.
# LEFTMOST_NODE=33590400
# RIGHTMOST_NODE=33590407
#these are better:
# LEFTMOST_NODE=33590398
# RIGHTMOST_NODE=33590415
# META=variant-3

# this is for variant 4
# """
# < chr6	7103348	7103348	1	*	PASS	INS	62	1	T	12	TRUE	TRUE
# """
#NOTE: these node ranges were too short.
# LEFTMOST_NODE=33801462
# RIGHTMOST_NODE=33801468
# META=variant-4
#these are better:
# LEFTMOST_NODE=33801461
# RIGHTMOST_NODE=33801630
# META=variant-4



# this is for variant 5
# """
# < chr6	12167581	12167581	1	*	PASS	INS	50	2	C	20	TRUE	TRUE
# """
#NOTE: these node ranges were too short.
# LEFTMOST_NODE=33960390
# RIGHTMOST_NODE=33960395
# META=variant-5
#these are better:
LEFTMOST_NODE=33960387
RIGHTMOST_NODE=33960586
META=variant-5

#Changing these variables will change whether you're looking at the names of the reads 
# mapped to the region in the unnorm graph or the norm graph. (You will extract the chosen
# reads from both unnorm and norm either way.)
GAM_BASE=hg38-hsvlr_srdedup17_aug.chr6.mpmap-aln.sorted
GRAPH=hg38-hsvlr_srdedup17_aug.chr6.xg
# GAM_BASE=hg38-hsvlr_srdedup17_aug.chr6.normalized.mpmap-aln.sorted
# hg38-hsvlr_srdedup17_aug.chr6.normalized.xg

#These are the files from which reads will be extracted from (based on above read names). Should be both norm and unnorm:
UNNORM_SAM=hg38-hsvlr_srdedup17_aug.chr6.mpmap-aln.chr6-surject.sam
NORM_SAM=hg38-hsvlr_srdedup17_aug.chr6.normalized.mpmap-aln.chr6-surject.sam

#This never changes:
OUTFILE_BASE=reads-for-comparison/${GAM_BASE}.${META}.find-nodes-${LEFTMOST_NODE}-${RIGHTMOST_NODE}
CHR=chr6

# extracts the gam for just the reads of interest.
vg find -x ${GRAPH} -o ${LEFTMOST_NODE}:${RIGHTMOST_NODE} -l ${GAM_BASE}.gam > ${OUTFILE_BASE}.gam
vg view -aj ${OUTFILE_BASE}.gam | jq -r '.name' > ${OUTFILE_BASE}.gam.read-names.txt && echo "done with view" &&
grep -f ${OUTFILE_BASE}.gam.read-names.txt ${UNNORM_SAM} > ${OUTFILE_BASE}.gam.reads-extracted-from-unnorm-surjected.sam && echo "done with unnorm grep" &&
grep -f ${OUTFILE_BASE}.gam.read-names.txt ${NORM_SAM} > ${OUTFILE_BASE}.gam.reads-extracted-from-norm-surjected.sam && echo "done with norm grep"


# grep -f ${GAM_BASE}.find-nodes-${LEFTMOST_NODE}-${RIGHTMOST_NODE}.gam.read-names.txt ${SAM} > hg38-hsvlr_srdedup17_aug.chr6.normalized.mpmap-aln.chr6-surject.reads-mapped-between-nodes-${LEFTMOST_NODE}-${RIGHTMOST_NODE}-in-unnorm.sam


########
# this is much faster than above, but it only extracts reads that are mapped to given 
#       location. It doesn't give the mappings for those same reads to places outside the given location.
# vg find -x ${GRAPH} -o ${LEFTMOST_NODE}:${RIGHTMOST_NODE} -l ${GAM_BASE}.gam > ${OUTFILE_BASE}.gam
# vg surject -x ${GRAPH} -t 14 -p ${CHR} -s ${OUTFILE_BASE}.gam >${OUTFILE_BASE}.gam-surjected-to-${CHR}.sam

