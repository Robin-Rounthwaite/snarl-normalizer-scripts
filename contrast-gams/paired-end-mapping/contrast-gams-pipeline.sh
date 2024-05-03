set -ex
CURRENT_DIR=$pwd
cd ~/paten_lab/vg-team/vg && . ./source_me.sh && cd ${CURRENT_DIR}
#command: /home/robin/paten_lab/vg-team/vg/robin-scripts/contrast-gams/paired-end-mapping/contrast-gams-pipeline.sh

##chr19:
#where to find json files and place contrast output:
INPUT_DIR=~/paten_lab/vg-team/vg/robin-graphs/nygc-chr19
OUTPUT_DIR=~/paten_lab/vg-team/vg/robin-graphs/nygc-chr19/contrast-gams
#where the parse-json, aggregate... etc. python scripts are:
SCRIPT_DIR=/home/robin/paten_lab/vg-team/vg/robin-scripts/contrast-gams/paired-end-mapping
#where the unnormalized & Normalized compared.json is:
UNNORM_JSON=${INPUT_DIR}/unnormalized.nygc.chr19.hg002.grch38-ref.pansn.compared.json
NORM_JSON=${INPUT_DIR}/normalized.nygc.chr19.hg002.grch38-ref.pansn.compared.json
UNNORM_GRAPH=${INPUT_DIR}/nygc.chr19.pg
NORM_GRAPH=${INPUT_DIR}/graph.combined.n32.desegregated-regions.normalized.pg
UNNORM_GAM=${INPUT_DIR}/graph.1m-giraffe-mapping.gam
NORM_GAM=${INPUT_DIR}/graph.combined.n32.desegregated-regions.normalized.1m-giraffe-mapping.gam

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
KEYWORD=0

#the following is the code that does all the heavy lifting in analyzing the jsons:
# python ${SCRIPT_DIR}/parse-json.py ${UNNORM_JSON} ${NORM_JSON} out-unnorm-norm.${REFORMATTED}.parsed-json.txt
# mkdir --parents ${OUTPUT_DIR}/aggregated_mappings/
# python ${SCRIPT_DIR}/aggregate-mappings-by-mapq-and-accuracy.py out-unnorm-norm.${REFORMATTED}.parsed-json.txt ${OUTPUT_DIR}/aggregated_mappings/${KEYWORD}
for DICT_NAME in dropping_mapq gaining_mapq #, maintaining_high_mapq]:
do
    for FIELD in accurate_to_accurate dropping_accuracy gaining_accuracy inaccurate_to_inaccurate half_accurate_to_half_accurate
    do
        if [ -f ${OUTPUT_DIR}/aggregated_mappings/${KEYWORD}.${DICT_NAME}.${FIELD}.txt ]; then
            # outf = open(outfile_prefix + "." + dict_name + "." + field + ".txt", "w")
            echo "visualizing file aggregated_mappings/${KEYWORD}.${DICT_NAME}.${FIELD}.txt"
            mkdir -p ${OUTPUT_DIR}/${DICT_NAME}/${FIELD}/
            python ${SCRIPT_DIR}/visualize-mapping-changes.py -a ${OUTPUT_DIR}/aggregated_mappings/${KEYWORD}.${DICT_NAME}.${FIELD}.txt -u ${UNNORM_GRAPH} -n ${NORM_GRAPH} -f ${UNNORM_GAM} -g ${NORM_GAM} -o ${OUTPUT_DIR}/${DICT_NAME}/${FIELD}/${KEYWORD}
        fi
    done
done