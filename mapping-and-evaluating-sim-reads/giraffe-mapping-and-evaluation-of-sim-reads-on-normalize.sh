#!/bin/bash
set -ex
cd /private/groups/patenlab/rrounthw/vg
# git pull
. ./source_me.sh #&& make -j 20
cd /private/groups/patenlab/rrounthw/nygc/chr21

########## Below uses sim reads from file robin-scripts/general-mustard-commands/simulating-reads-on-hg002-chr21.sh

#first experiment. Found that the two graphs looked nearly identical in mappings. Perhaps because reads were simmed from the graph that was being normalized?
# TRUTH_GAM=reads-sim-1m-from-graph-pg.gam #This file uses the same graph that I'm normalizing, which is an issue.
# NORM_GAM=graph.combined.n32.desegregated-regions.normalized.1m-giraffe-mapping.gam
# UNNORM_GAM=graph.1m-giraffe-mapping.gam

#second experiment: sim reads from hg002, and get those regions.
TRUTH_GAM=sim-1m-hg002-chr21-reads.hprc-chm-hg002-aug15.full.gam #reads all simulated from full hg002 paths in chr21.
NORM_GAM=graph.combined.n32.desegregated-regions.normalized.1m-hg002-chr21-reads.gam
UNNORM_GAM=graph.unnormalized.1m-hg002-chr21-reads.gam

#mapping to normalized
nice time vg giraffe -m graph.combined.n32.desegregated-regions.normalized.min -d graph.combined.n32.desegregated-regions.normalized.dist -g graph.combined.n32.desegregated-regions.normalized.gbwt.gg -H graph.combined.n32.desegregated-regions.normalized.gbwt -i -G ${TRUTH_GAM} -p -t 22 > ${NORM_GAM} &&
#mapping to unnormalized
nice time vg giraffe -m graph.min -d graph.dist -g graph.combined.gbwt.gg -H graph.combined.gbwt -i -G ${TRUTH_GAM} -p -t 22 > ${UNNORM_GAM} &&


get_roc_stats () {
    echo "running get_roc_stats"
    TRUTH=$1 # this is the truth set gam (e.g. reads.gam), i.e. the gam the simulated reads came in.
    MAPPED=$2 # the re-mapped reads (e.g. mapped.gam) that we'll be scoring.
    GRAPH=$3 # the graph we mapped the reads to.
    REPORT=$4 # the report.tsv. This will be APPPENDED to, not overwritten. So that we can run this function multiple times and stack up statistics.
    ROC_STATS=$5 # the roc_stats.tsv. Same as above, will be APPENDED to.
    TYPE=$6 #e.g. unnormalized or normalized.
    KEYWORD=$7
    COMPARED=${TYPE}.${KEYWORD}.compared.json
    COUNT=${TYPE}.${KEYWORD}.count

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

#make the summary stats for unnormalized
# REPORT=report.tsv
# ROC_STATS=roc_stats.tsv
# REPORT=report_full.tsv
# ROC_STATS=roc_stats_full.tsv
KEYWORD=hg002
REPORT=report.${KEYWORD}.tsv
ROC_STATS=roc_stats.${KEYWORD}.tsv
cat /dev/null > ${REPORT} &&
cat /dev/null > ${ROC_STATS} &&
echo "correct\tmq\tscore\tread_name\taligner" >${ROC_STATS}
# get_roc_stats TRUTH MAPPED GRAPH REPORT ROC_STATS

GBWT=unnorm-gbwt
READS=10m-sim-reads
PARAM_PRESET=default
PAIRING=paired
SPEED=normal-speed
# CORRECT_COUNT=
# MAPQ=
# MAPQ60=
# IDENTITY=
# SCORE=

get_roc_stats ${TRUTH_GAM} ${UNNORM_GAM} graph.pg ${REPORT} ${ROC_STATS} unnormalized ${KEYWORD}&&

GBWT=norm-gbwt
#make the summary stats for normalized
get_roc_stats ${TRUTH_GAM} ${NORM_GAM} graph.combined.n32.desegregated-regions.normalized.pg ${REPORT} ${ROC_STATS} normalized ${KEYWORD}&&
sed -i 's/null/-1/g' ${ROC_STATS} #turn nulls into -1 so that they don't mess up the plot-qq/plot-roc.
gzip -f ${ROC_STATS}



# #scratch:
# sed -i 's/null/-1/g' roc_stats_reformatted.tsv #turn nulls into -1 so that they don't mess up the plot-qq/plot-roc.
# sed -i "1i correct\tmq\tscore\tread_name\taligner" roc_stats_reformatted.tsv
# get_roc_stats () {
#     echo "running get_roc_stats"
#     TRUTH=$1 # this is the truth set gam (e.g. reads.gam), i.e. the gam the simulated reads came in.
#     MAPPED=$2 # the re-mapped reads (e.g. mapped.gam) that we'll be scoring.
#     GRAPH=$3 # the graph we mapped the reads to.
#     REPORT=$4 # the report.tsv. This will be APPPENDED to, not overwritten. So that we can run this function multiple times and stack up statistics.
#     ROC_STATS=$5 # the roc_stats.tsv. Same as above, will be APPENDED to.
    
#     vg gamcompare -r 100 -s <(vg annotate -m -x ${GRAPH} -a ${MAPPED}) ${TRUTH} 2>count | vg view -aj - > compared.json
# }
# get_roc_stats ${TRUTH_GAM} ${UNNORM_GAM} graph.pg report.tsv roc_stats.tsv



#############################
# #mustard: normalizing and giraffe mapping to chr21.
# cd /private/groups/patenlab/rrounthw/vg
# git pull
# . ./source_me.sh && make -j 20
# cd /private/groups/patenlab/rrounthw/nygc/chr21
# echo "running normalize." && #graph.combined.n32.segregated-regions.gbwt graph.combined.n32.desegregated-regions.gbwt
# nice time vg normalize --run_tests -d graph.dist -g graph.combined.n32.segregated-regions.gbwt -r graph.combined.n32.segregated-regions.gbwt.gg -t 20 -n 32 -o graph.combined.n32.desegregated-regions.normalized.gbwt -S graph.combined.n32.segregated-regions-data.txt graph.combined.n32.segregated-regions.pg > graph.combined.n32.desegregated-regions.normalized.pg 2> graph.combined.n32.desegregated-regions.normalized.stderr
# echo "done normalizing, making gbwt graph"
# nice time vg gbwt -g graph.combined.n32.desegregated-regions.normalized.gbwt.gg -x graph.combined.n32.desegregated-regions.normalized.pg graph.combined.n32.desegregated-regions.normalized.gbwt
# echo "done making gbwt graph, starting distance indexing"
# nice time vg index -j graph.combined.n32.desegregated-regions.normalized.dist graph.combined.n32.desegregated-regions.normalized.pg
# echo "done with index, starting minimizer file"
# nice time vg minimizer -g graph.combined.n32.desegregated-regions.normalized.gbwt -d graph.combined.n32.desegregated-regions.normalized.dist -o graph.combined.n32.desegregated-regions.normalized.min graph.combined.n32.desegregated-regions.normalized.pg

#where we left off:
# echo "done with minimizer, simulating reads" &&
# vg sim --num-reads 1000000 --frag-len 500 --read-length 100 --random-seed 9999 --any-path --progress -x graph.pg --align-out >${TRUTH_GAM} &&
# echo "done with simulating reads, running vg giraffe" &&
# nice time vg giraffe -m graph.combined.n32.desegregated-regions.normalized.min -d graph.combined.n32.desegregated-regions.normalized.dist -g graph.combined.n32.desegregated-regions.normalized.gbwt.gg -H graph.combined.n32.desegregated-regions.normalized.gbwt -i -G ${TRUTH_GAM} -p -t 22 > ${NORM_GAM} &&

# echo "running for unnormalized also..." &&
# echo "making minimizer" &&
# nice time vg minimizer -g graph.combined.gbwt -d graph.dist -o graph.min graph.pg &&
# echo "running unnormalized giraffe." &&
# nice time vg giraffe -m graph.min -d graph.dist -g graph.combined.gbwt.gg -H graph.combined.gbwt -i -G ${TRUTH_GAM} -p -t 22 > ${UNNORM_GAM} &&
# echo "done" &&

########## (above is early draft code.)