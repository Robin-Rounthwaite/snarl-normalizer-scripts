#####NYGC full genome
#unnormalized
OUTFILE_BASE=/public/groups/vg/rrounthw/nygc_normalize/giraffe-mapping-full-genome
INFILE_BASE=/public/groups/vg/rrounthw/nygc_normalize
READS_GAM=/public/groups/vg/rrounthw/jean-combined-sv-graph/HG002-hg38-hsvlr_srdedup17_aug.giraffe29k11w32N_fast.gam
DIST=${INFILE_BASE}/nygc_snp1kg_grch38.dist
MIN=${INFILE_BASE}/nygc_snp1kg_grch38.k29.w11.min
GBWT=${INFILE_BASE}/nygc_snp1kg_grch38.all.gbwt
XG=${INFILE_BASE}/nygc_snp1kg_grch38.xg
GIRAFFE_GBWT=${INFILE_BASE}/nygc_snp1kg_grch38.giraffe.gbwt
GIRAFFE_GBZ=${INFILE_BASE}/nygc_snp1kg_grch38.giraffe.gbz
MAPPED_GAM=${OUTFILE_BASE}/nygc_snp1kg_grch38.robin-giraffe-29k11w32N.gam
THREADS=14

nice vg gbwt -x ${XG} -o ${GIRAFFE_GBWT} -l ${GBWT}
nice vg gbwt -g ${GIRAFFE_GBZ} --gbz-format -x ${XG} ${GIRAFFE_GBWT}
nice vg index -t ${THREADS} -j ${DIST} ${XG}
nice vg minimizer -d ${DIST} -k 29 -w 11 -t ${THREADS} ${GIRAFFE_GBZ} -o ${MIN}
nice time vg giraffe -x ${XG} -Z ${GIRAFFE_GBZ} -m ${MIN} -d ${DIST} -G ${READS_GAM} -i -t 22 > ${MAPPED_GAM} 

#normalized
OUTFILE_BASE=/public/groups/vg/rrounthw/nygc_normalize/giraffe-mapping-full-genome
INFILE_BASE=/public/groups/vg/rrounthw/nygc_normalize
READS_GAM=/public/groups/vg/rrounthw/jean-combined-sv-graph/HG002-hg38-hsvlr_srdedup17_aug.giraffe29k11w32N_fast.gam
DIST=${INFILE_BASE}/nygc_snp1kg_grch38.normalized.dist
MIN=${INFILE_BASE}/nygc_snp1kg_grch38.normalized.k29.w11.min
GBWT=${INFILE_BASE}/nygc_snp1kg_grch38.normalized.all.gbwt
PG=${INFILE_BASE}/nygc_snp1kg_grch38.normalized.pg
XG=${INFILE_BASE}/nygc_snp1kg_grch38.normalized.xg
GIRAFFE_GBWT=${INFILE_BASE}/nygc_snp1kg_grch38.normalized.giraffe.gbwt
GIRAFFE_GBZ=${INFILE_BASE}/nygc_snp1kg_grch38.normalized.giraffe.gbz
MAPPED_GAM=${OUTFILE_BASE}/nygc_snp1kg_grch38.normalized.robin-giraffe-29k11w32N.gam
THREADS=14

#arguments needed for normalize:
UNNORMALIZED_GBWT=${INFILE_BASE}/nygc_snp1kg_grch38.all.gbwt
UNNORMALIZED_GG=${INFILE_BASE}/nygc_snp1kg_grch38.all.gg
UNNORMALIZED_XG=${INFILE_BASE}/nygc_snp1kg_grch38.xg
UNNORMALIZED_PG=${INFILE_BASE}/nygc_snp1kg_grch38.pg
UNNORMALIZED_SNARLS=${INFILE_BASE}/nygc_snp1kg_grch38.snarls.pb

nice vg gbwt -x ${UNNORMALIZED_XG} -g ${UNNORMALIZED_GG} ${UNNORMALIZED_GBWT}
nice vg normalize -s ${UNNORMALIZED_SNARLS} -g ${UNNORMALIZED_GBWT} -r ${UNNORMALIZED_GG} -o ${GBWT} ${UNNORMALIZED_PG} >${PG}
nice vg convert -x ${PG} >${XG}

nice vg gbwt -x ${XG} -o ${GIRAFFE_GBWT} -l ${GBWT}
nice vg gbwt -g ${GIRAFFE_GBZ} --gbz-format -x ${XG} ${GIRAFFE_GBWT}
nice vg index -t ${THREADS} -j ${DIST} ${XG}
nice vg minimizer -d ${DIST} -k 29 -w 11 -t ${THREADS} ${GIRAFFE_GBZ} -o ${MIN}
nice time vg giraffe -x ${XG} -Z ${GIRAFFE_GBZ} -m ${MIN} -d ${DIST} -G ${READS_GAM} -i -t 22 > ${MAPPED_GAM} 















#####Jean-graph (hg38-hsvlr)
#unnormalized
OUTFILE_BASE=/public/groups/vg/rrounthw/jean-combined-sv-graph/giraffe-mapping-full-genome
INFILE_BASE=/public/groups/vg/rrounthw/jean-combined-sv-graph
READS_GAM=${INFILE_BASE}/HG002-hg38-hsvlr_srdedup17_aug.giraffe29k11w32N_fast.gam
DIST=${INFILE_BASE}/hg38-hsvlr_srdedup17_aug.new.dist
MIN=${INFILE_BASE}/hg38-hsvlr_srdedup17_aug.k29.w11.new.min
GBWT=${INFILE_BASE}/hg38-hsvlr_srdedup17_aug.N32.gbwt
XG=${INFILE_BASE}/hg38-hsvlr_srdedup17_aug.xg
GIRAFFE_GBWT=${INFILE_BASE}/hg38-hsvlr_srdedup17_aug.giraffe.gbwt
GIRAFFE_GBZ=${INFILE_BASE}/hg38-hsvlr_srdedup17_aug.giraffe.gbz
MAPPED_GAM=${OUTFILE_BASE}/hg38-hsvlr_srdedup17_aug.robin-giraffe-29k11w32N.gam
THREADS=14

# nice vg index -t ${THREADS} -j ${DIST} ${XG}
# nice vg minimizer -d ${DIST} -k 29 -w 11 -t ${THREADS} ${GIRAFFE_GBZ} -o ${MIN}
nice time vg giraffe -x ${XG} -Z ${GIRAFFE_GBZ} -m ${MIN} -d ${DIST} -G ${READS_GAM} -i -t 22 > ${MAPPED_GAM} 

#normalized
OUTFILE_BASE=/public/groups/vg/rrounthw/jean-combined-sv-graph/giraffe-mapping-full-genome
INFILE_BASE=/public/groups/vg/rrounthw/jean-combined-sv-graph
READS_GAM=${INFILE_BASE}/HG002-hg38-hsvlr_srdedup17_aug.giraffe29k11w32N_fast.gam
DIST=${INFILE_BASE}/hg38-hsvlr_srdedup17_aug.normalized.dist
MIN=${INFILE_BASE}/hg38-hsvlr_srdedup17_aug.normalized.k29.w11.min
GBWT=${INFILE_BASE}/hg38-hsvlr_srdedup17_aug.normalized.gbwt
XG=${INFILE_BASE}/hg38-hsvlr_srdedup17_aug.normalized.xg
GIRAFFE_GBWT=${INFILE_BASE}/hg38-hsvlr_srdedup17_aug.normalized.giraffe.gbwt
GIRAFFE_GBZ=${INFILE_BASE}/hg38-hsvlr_srdedup17_aug.normalized.giraffe.gbz
MAPPED_GAM=${OUTFILE_BASE}/hg38-hsvlr_srdedup17_aug.normalized.robin-giraffe-29k11w32N.gam
THREADS=14

# nice vg index -t ${THREADS} -j ${DIST} ${XG}
# nice vg minimizer -d ${DIST} -k 29 -w 11 -t ${THREADS} ${GIRAFFE_GBZ} -o ${MIN}
nice time vg giraffe -x ${XG} -Z ${GIRAFFE_GBZ} -m ${MIN} -d ${DIST} -G ${READS_GAM} -i -t 22 > ${MAPPED_GAM} 


# vg gbwt -x ${XG} -o ${GIRAFFE_GBWT} -l ${GBWT}
# vg gbwt -g ${GIRAFFE_GBZ} --gbz-format -x ${XG} ${GIRAFFE_GBWT}
