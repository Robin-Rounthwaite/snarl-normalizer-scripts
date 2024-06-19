set -ex
CURRENT_DIR=$pwd
cd ~/paten_lab/vg-team/vg && . ./source_me.sh && cd ${CURRENT_DIR}
#command: /home/robin/paten_lab/vg-team/vg/robin-scripts/contrast-gams/paired-end-mapping/contrast-gams-pipeline.sh

##chr19:
#where to find json files and place contrast output:
INPUT_DIR=~/paten_lab/vg-team/vg/robin-graphs/nygc-chr19
########## OUTPUT_DIR=~/paten_lab/vg-team/vg/robin-graphs/nygc-chr19/test
OUTPUT_DIR=~/paten_lab/vg-team/vg/robin-graphs/nygc-chr19/contrast-gams
# mkdir --parents ${OUTPUT_DIR}
#where the parse-json, aggregate... etc. python scripts are:
SCRIPT_DIR=/home/robin/paten_lab/vg-team/vg/robin-scripts/contrast-gams/paired-end-mapping
EXPERIMENT_DIR=${INPUT_DIR}/gamcompare-depth-50

#where the unnormalized & Normalized compared.json is:
# gunzip ${EXPERIMENT_DIR}/unnormalized.nygc.chr19.sim-6m-hg002-chr19-reads.grch38-ref.pansn.compared.json.gz
# gunzip ${EXPERIMENT_DIR}/normalized.nygc.chr19.sim-6m-hg002-chr19-reads.grch38-ref.pansn.compared.json.gz
UNNORM_JSON=${EXPERIMENT_DIR}/unnormalized.nygc.chr19.sim-6m-hg002-chr19-reads.grch38-ref.pansn.compared.json
NORM_JSON=${EXPERIMENT_DIR}/normalized.nygc.chr19.sim-6m-hg002-chr19-reads.grch38-ref.pansn.compared.json
UNNORM_GRAPH=${INPUT_DIR}/nygc.chr19.pg
NORM_GRAPH=${INPUT_DIR}/nygc.chr19.desegregated.normalized-directly-from-unnorm.grch38-ref.pansn.pg
UNNORM_GAM=${EXPERIMENT_DIR}/nygc.chr19.sim-6m-hg002-chr19-reads.gam
NORM_GAM=${EXPERIMENT_DIR}/nygc.chr19.desegregated.normalized-directly-from-unnorm.sim-6m-hg002-chr19-reads.gam

##Chr21:
#where the parse-json, aggregate... etc. python scripts are:
# SCRIPT_DIR=/home/robin/paten_lab/vg-team/vg/robin-scripts/contrast-gams/paired-end-mapping
# INPUT_DIR=~/paten_lab/vg-team/vg/robin-graphs/nygc-chr21-segregated-regions/giraffe-stats
#where the parse-json, aggregate... etc. python scripts are:
# OUTPUT_DIR=~/paten_lab/vg-team/vg/robin-graphs/nygc-chr21-segregated-regions/giraffe-stats/contrast-gams
# #where the unnormalized & Normalized compared.json is:
# UNNORM_JSON=${INPUT_DIR}/unnormalized.reformatted.compared.json
# NORM_JSON=${INPUT_DIR}/normalized.reformatted.compared.json
# UNNORM_GRAPH=${INPUT_DIR}/graph.pg
# NORM_GRAPH=${INPUT_DIR}/graph.combined.n32.desegregated-regions.normalized.pg
# UNNORM_GAM=${INPUT_DIR}/graph.1m-giraffe-mapping.gam
# NORM_GAM=${INPUT_DIR}/graph.combined.n32.desegregated-regions.normalized.1m-giraffe-mapping.gam

#a keyword for differentiating different file runs:
KEYWORD=DEPTH-50
# VIZ_FOLDER_KEYWORD=3-of-each-field
MAX_COUNT=3

#the following is the code that does all the heavy lifting in analyzing the jsons:
    #for on mustard:
    KEYWORD=DEPTH-50
    NORM=normalized.nygc.chr19.sim-6m-hg002-chr19-reads.grch38-ref.pansn.compared.json
    UNNORM=unnormalized.nygc.chr19.sim-6m-hg002-chr19-reads.grch38-ref.pansn.compared.json
    # gunzip ${NORM}.gz
    # gunzip ${UNNORM}.gz
    mkdir parsed-json
    python3 parse-json.py ${UNNORM} ${NORM} parsed-json/out-unnorm-norm.${KEYWORD}.parsed-json.txt
python ${SCRIPT_DIR}/parse-json.py ${UNNORM_JSON} ${NORM_JSON} ${OUTPUT_DIR}/out-unnorm-norm.${KEYWORD}.parsed-json.txt
mkdir --parents ${OUTPUT_DIR}/aggregated_mappings/
python ${SCRIPT_DIR}/aggregate-mappings-by-mapq-and-accuracy.py ${OUTPUT_DIR}/out-unnorm-norm.${KEYWORD}.parsed-json.txt ${OUTPUT_DIR}/aggregated_mappings/${KEYWORD}
# python ${SCRIPT_DIR}/aggregate-mappings-by-mapq-and-accuracy.py ${OUTPUT_DIR}/out-unnorm-norm.${KEYWORD}.parsed-json.txt ${OUTPUT_DIR}/test
# for DICT_NAME in gaining_mapq dropping_mapq #, maintaining_high_mapq]:
# do
#     for FIELD in accurate_to_accurate dropping_accuracy gaining_accuracy inaccurate_to_inaccurate half_accurate_to_half_accurate
#     do
#         if [ -f ${OUTPUT_DIR}/aggregated_mappings/${KEYWORD}.${DICT_NAME}.${FIELD}.txt ]; then
#             echo "visualizing file aggregated_mappings/${KEYWORD}.${DICT_NAME}.${FIELD}.txt"
#             mkdir -p ${OUTPUT_DIR}/${DICT_NAME}/${FIELD}/
#             python ${SCRIPT_DIR}/visualize-mapping-changes.py -m ${MAX_COUNT} -a ${OUTPUT_DIR}/aggregated_mappings/${KEYWORD}.${DICT_NAME}.${FIELD}.txt -u ${UNNORM_GRAPH} -n ${NORM_GRAPH} -f ${UNNORM_GAM} -g ${NORM_GAM} -c 8 -o ${OUTPUT_DIR}/${DICT_NAME}/${FIELD}/${KEYWORD}
#         fi
#     done
# done