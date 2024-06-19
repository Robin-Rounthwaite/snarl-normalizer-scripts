set -ex
CURRENT_DIR=$pwd
cd ~/paten_lab/vg-team/vg && . ./source_me.sh && cd ${CURRENT_DIR}

####Example for writing a specific file to svg using visualize-mapping-changes.py (E.G. using shuf -n 3 aggregated-mappings-output.txt):
##chr19:
#where to find json files and place contrast output:
INPUT_DIR=~/paten_lab/vg-team/vg/robin-graphs/nygc-chr19
OUTPUT_DIR=~/paten_lab/vg-team/vg/robin-graphs/nygc-chr19/contrast-gams/visualize-mapping-changes
#where the parse-json, aggregate... etc. python scripts are:
SCRIPT_DIR=/home/robin/paten_lab/vg-team/vg/robin-scripts/contrast-gams/paired-end-mapping
#where the unnormalized & Normalized compared.json is:
UNNORM_GRAPH=${INPUT_DIR}/nygc.chr19.pg
#TODO: edit the following three lines:
# NORM_GRAPH=${INPUT_DIR}/nygc.chr19.desegregated.normalized-directly-from-unnorm.grch38-ref.pansn.pg 
# UNNORM_GAM=${INPUT_DIR}/graph.1m-giraffe-mapping.gam
# NORM_GAM=${INPUT_DIR}/graph.combined.n32.desegregated-regions.normalized.1m-giraffe-mapping.gam

# NORM_GRAPH=${INPUT_DIR}/graph.combined.n32.desegregated-regions.normalized.pg
# UNNORM_GAM=${INPUT_DIR}/graph.1m-giraffe-mapping.gam
# NORM_GAM=${INPUT_DIR}/graph.combined.n32.desegregated-regions.normalized.1m-giraffe-mapping.gam
KEYWORD=0

AGGREGATED_MAPPING_FILE=2024-05-07.0.dropping_mapq.dropping_accuracy.shuf_3.json
AGGREGATED_MAPPING_OUTPUT=${INPUT_DIR}/contrast-gams/${AGGREGATED_MAPPING_FILE} #note: this is not the output of visualize-mapping-changes.py, but rather the script before it in the pipeline.
mkdir -p ${OUTPUT_DIR}/${AGGREGATED_MAPPING_FILE}

python ${SCRIPT_DIR}/visualize-mapping-changes.py -a ${AGGREGATED_MAPPING_OUTPUT} -u ${UNNORM_GRAPH} -n ${NORM_GRAPH} -f ${UNNORM_GAM} -g ${NORM_GAM} -o ${OUTPUT_DIR}/${AGGREGATED_MAPPING_FILE}/${KEYWORD}
