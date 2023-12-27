#where the parse-json, aggregate... etc. python scripts are:
SCRIPT_DIR=/home/robin/paten_lab/vg-team/vg/robin-scripts/contrast-gams/paired-end-mapping
OUTPUT_DIR=~/paten_lab/vg-team/vg/robin-graphs/nygc-chr21-segregated-regions/giraffe-stats/constrast-gams
#where the unnormalized & Normalized compared.json is:
UNNORM_JSON=${OUTPUT_DIR}/unnormalized.reformatted.compared.json
NORM_JSON=${OUTPUT_DIR}/normalized.reformatted.compared.json
#a keyword for differentiating different file runs:
KEYWORD=reformatted


python ${SCRIPT_DIR}/parse-json.py ${UNNORM_JSON} ${NORM_JSON} out-unnorm-norm.${REFORMATTED}.parsed-json.txt
mkdir --parents ${OUTPUT_DIR}/aggregated_mappings/
python ${SCRIPT_DIR}/aggregate-mappings-by-mapq-and-accuracy.py out-unnorm-norm.${REFORMATTED}.parsed-json.txt ${OUTPUT_DIR}/aggregated_mappings/${KEYWORD}
for DICT_NAME in dropping_mapq, gaining_mapq #, maintaining_high_mapq]:
do
    for FIELD in accurate_to_accurate dropping_accuracy gaining_accuracy inaccurate_to_inaccurate half_accurate_to_half_accurate
    do
            # outf = open(outfile_prefix + "." + dict_name + "." + field + ".txt", "w")
        python ${SCRIPT_DIR}/visualize-mapping-changes.py -a ${OUTPUT_DIR}/aggregated_mappings/${KEYWORD}.${DICT_NAME}.${FIELD}.txt -u unnorm-graph.xg -n norm-graph.xg -f unnorm.gam -g norm.gam -o ${OUTPUT_DIR}/${KEYWORD} 
    done
done
for 
