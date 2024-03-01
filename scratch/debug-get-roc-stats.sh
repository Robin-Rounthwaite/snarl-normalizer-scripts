UNNORM_BASE=nygc.chr19
SEGREGATED_BASE=${UNNORM_BASE}.segregated-regions
NORM_BASE=${UNNORM_BASE}.desegregated.normalized

TRUTH_GAM=/private/groups/patenlab/rrounthw/nygc/chr19/sim-hg002-reads/sim-1m-reads.chr19-hg002.gam #reads all simulated from full hg002 paths in chr21.

READ_METADATA=1m-hg002-chr19-reads
NORM_GAM=${NORM_BASE}.${READ_METADATA}.gam
UNNORM_GAM=${UNNORM_BASE}.${READ_METADATA}.gam


##inline function for generating roc stats
get_roc_stats () {
    echo "running get_roc_stats"
    TRUTH=$1 # this is the truth set gam (e.g. reads.gam), i.e. the gam the simulated reads came in.
    MAPPED=$2 # the re-mapped reads (e.g. mapped.gam) that we'll be scoring.
    GRAPH=$3 # the graph we mapped the reads to.
    REPORT=$4 # the report.tsv. This will be APPPENDED to, not overwritten. So that we can run this function multiple times and stack up statistics.
    ROC_STATS=$5 # the roc_stats.tsv. Same as above, will be APPENDED to.
    TYPE=$6 #e.g. unnormalized or normalized. Should be kept nice and short for the use of the plotting software that uses this word to generate the plots.
    KEYWORD=$7
    COMPARED=${TYPE}.${KEYWORD}.compared.json
    COUNT=${TYPE}.${KEYWORD}.count


    ls -alt ${TRUTH} 
    ls -alt ${MAPPED} 
    ls -alt ${GRAPH} 
    ls -alt ${REPORT} 
    ls -alt ${ROC_STATS} 
    ls -alt ${TYPE} 
    ls -alt ${KEYWORD} 
    ls -alt ${COMPARED} 
    COUNT
}

    vg gamcompare -r 100 -s <(vg annotate -m -x ${GRAPH} -a ${MAPPED}) ${TRUTH} 2>${COUNT} | vg view -aj - > ${COMPARED}
    CORRECT_COUNT="$(sed -n '1p' ${COUNT} | sed 's/[^0-9]//g')"
    SCORE="$(sed -n '2p' ${COUNT} | sed 's/[^0-9\.]//g')"
    MAPQ="$(grep mapping_quality\":\ 60 ${COMPARED} | wc -l)"
    MAPQ60="$(grep -v correctly_mapped ${COMPARED} | grep mapping_quality\":\ 60 | wc -l)"
    IDENTITY="$(jq '.identity' ${COMPARED} | awk '{sum+=$1} END {print sum/NR}')"
    echo ${GRAPH} ${GBWT} ${READS} ${PARAM_PRESET}${PAIRING} ${SPEED} ${CORRECT_COUNT} ${MAPQ} ${MAPQ60} ${IDENTITY} ${SCORE}
    printf "${GRAPH}\t${GBWT}\t${READS}\t${PARAM_PRESET}\t${PAIRING}\t${SPEED}\t${CORRECT_COUNT}\t${MAPQ}\t${MAPQ60}\t${IDENTITY}\t${SCORE}\n" >> ${REPORT}
    # jq -r '(if .correctly_mapped then 1 else 0 end|tostring) + "," + (.mapping_quality|tostring) + "," + (.score|tostring)' ${COMPARED} | sed 's/,/\t/g' | sed "s/$/\tgiraffe_${PARAM_PRESET}_${GRAPH}${GBWT}${READS}${PAIRING}/" >> ${ROC_STATS} # this is the original entry, which causes bugs with plot-qq and plot-roc.r #todo: save useful data like read_name and score in a way that doesn't mess up the plots.
    # jq -r '(if .correctly_mapped then 1 else 0 end|tostring) + "," + (.mapping_quality|tostring)' ${COMPARED} | sed 's/,/\t/g' | sed "s/$/\t${TYPE}/" >> ${ROC_STATS}
    jq -r '(if .correctly_mapped then 1 else 0 end|tostring) + "," + (.mapping_quality|tostring) + "," + (.score|tostring) + "," + (.name|tostring)' ${COMPARED} | sed 's/,/\t/g' | sed "s/$/\t${TYPE}/" >> ${ROC_STATS}
    gzip -f ${COMPARED}
    gzip -f ${COUNT}
    # rm compared.json count #removes the tmp files that this function created.
}

#start to make summary stats
KEYWORD=${UNNORM_BASE}.debug
REPORT=report.${KEYWORD}.tsv
ROC_STATS=roc_stats.${KEYWORD}.tsv
cat /dev/null > ${REPORT} &&
cat /dev/null > ${ROC_STATS} &&
echo "correct\tmq\tscore\tread_name\taligner" >${ROC_STATS}

READS=10m-sim-reads
PARAM_PRESET=default
PAIRING=paired
SPEED=normal-speed

#get roc stats unnormalized
GBWT=unnorm-gbwt
get_roc_stats ${TRUTH_GAM} ${UNNORM_GAM} graph.pg ${REPORT} ${ROC_STATS} unnormalized ${KEYWORD}

GBWT=norm-gbwt
#make the summary stats for normalized
get_roc_stats ${TRUTH_GAM} ${NORM_GAM} graph.combined.n32.desegregated-regions.normalized.pg ${REPORT} ${ROC_STATS} normalized ${KEYWORD}&&
sed -i 's/null/-1/g' ${ROC_STATS} #turn nulls into -1 so that they don't mess up the plot-qq/plot-roc.
gzip -f ${ROC_STATS}

