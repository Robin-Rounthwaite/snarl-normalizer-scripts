#!/bin/bash
set -e
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
# vg sim --num-reads 1000000 --frag-len 500 --read-length 100 --random-seed 9999 --any-path --progress -x graph.pg --align-out >reads-sim-1m-from-graph-pg.gam &&
echo "done with simulating reads, running vg giraffe" &&
nice time vg giraffe -m graph.combined.n32.desegregated-regions.normalized.min -d graph.combined.n32.desegregated-regions.normalized.dist -g graph.combined.n32.desegregated-regions.normalized.gbwt.gg -H graph.combined.n32.desegregated-regions.normalized.gbwt -i -G reads-sim-1m-from-graph-pg.gam -p -t 22 > graph.combined.n32.desegregated-regions.normalized.1m-giraffe-mapping.gam &&

echo "running for unnormalized also..." &&
# echo "making minimizer" &&
# nice time vg minimizer -g graph.combined.gbwt -d graph.dist -o graph.min graph.pg &&
echo "running unnormalized giraffe." &&
nice time vg giraffe -m graph.min -d graph.dist -g graph.combined.gbwt.gg -H graph.combined.gbwt -i -G reads-sim-1m-from-graph-pg.gam -p -t 22 > graph.1m-giraffe-mapping.gam &&
echo "done" &&

get_roc_stats () {
    echo "running get_roc_stats"
    TRUTH=$1 # this is the truth set gam (e.g. reads.gam), i.e. the gam the simulated reads came in.
    MAPPED=$2 # the re-mapped reads (e.g. mapped.gam) that we'll be scoring.
    GRAPH=$3 # the graph we mapped the reads to.
    REPORT=$4 # the report.tsv. This will be APPPENDED to, not overwritten. So that we can run this function multiple times and stack up statistics.
    ROC_STATS=$5 # the roc_stats.tsv. Same as above, will be APPENDED to.
    
    vg gamcompare -r 100 -s <(vg annotate -m -x ${GRAPH} -a ${MAPPED}) ${TRUTH} 2>count | vg view -aj - > compared.json
    CORRECT_COUNT="$(sed -n '1p' count | sed 's/[^0-9]//g')"
    SCORE="$(sed -n '2p' count | sed 's/[^0-9\.]//g')"
    MAPQ="$(grep mapping_quality\":\ 60 compared.json | wc -l)"
    MAPQ60="$(grep -v correctly_mapped compared.json | grep mapping_quality\":\ 60 | wc -l)"
    IDENTITY="$(jq '.identity' compared.json | awk '{sum+=$1} END {print sum/NR}')"
    echo ${GRAPH} ${GBWT} ${READS} ${PARAM_PRESET}${PAIRING} ${SPEED} ${CORRECT_COUNT} ${MAPQ} ${MAPQ60} ${IDENTITY} ${SCORE}
    printf "${GRAPH}\t${GBWT}\t${READS}\t${PARAM_PRESET}\t${PAIRING}\t${SPEED}\t${CORRECT_COUNT}\t${MAPQ}\t${MAPQ60}\t${IDENTITY}\t${SCORE}\n" >> ${REPORT}
    jq -r '(if .correctly_mapped then 1 else 0 end|tostring) + "," + (.mapping_quality|tostring) + "," + (.score|tostring)' compared.json | sed 's/,/\t/g' | sed "s/$/\tgiraffe_${PARAM_PRESET}_${GRAPH}${GBWT}${READS}${PAIRING}/" >> ${ROC_STATS}
    rm compared.json count #removes the tmp files that this function created.
}

#make the summary stats for unnormalized
# REPORT=report.tsv
# ROC_STATS=roc_stats.tsv
REPORT=report_full.tsv
ROC_STATS=roc_stats_full.tsv
cat /dev/null > ${REPORT} &&
cat /dev/null > ${ROC_STATS} &&
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

get_roc_stats reads-sim-1m-from-graph-pg.gam graph.1m-giraffe-mapping.gam graph.pg ${REPORT} ${ROC_STATS} &&

GBWT=norm-gbwt
#make the summary stats for normalized
get_roc_stats reads-sim-1m-from-graph-pg.gam graph.combined.n32.desegregated-regions.normalized.1m-giraffe-mapping.gam graph.combined.n32.desegregated-regions.normalized.pg ${REPORT} ${ROC_STATS} &&

gzip roc_stats.tsv



# #scratch:
# get_roc_stats () {
#     echo "running get_roc_stats"
#     TRUTH=$1 # this is the truth set gam (e.g. reads.gam), i.e. the gam the simulated reads came in.
#     MAPPED=$2 # the re-mapped reads (e.g. mapped.gam) that we'll be scoring.
#     GRAPH=$3 # the graph we mapped the reads to.
#     REPORT=$4 # the report.tsv. This will be APPPENDED to, not overwritten. So that we can run this function multiple times and stack up statistics.
#     ROC_STATS=$5 # the roc_stats.tsv. Same as above, will be APPENDED to.
    
#     vg gamcompare -r 100 -s <(vg annotate -m -x ${GRAPH} -a ${MAPPED}) ${TRUTH} 2>count | vg view -aj - > compared.json
# }
# get_roc_stats reads-sim-1m-from-graph-pg.gam graph.1m-giraffe-mapping.gam graph.pg report.tsv roc_stats.tsv
