set -ex
CURRENT_DIR=$pwd
cd ~/paten_lab/vg-team/vg && . ./source_me.sh && make -j 20 && cd ${CURRENT_DIR}

INPUT_DIR=/home/robin/paten_lab/vg-team/vg/robin-graphs/nygc-chr19

REGION_START=3633719
REGION_END=3633726
SINGLE_REGION_FILE_BASE=norm-single-region.${REGION_START}-${REGION_END}

UNNORM_BASE=${INPUT_DIR}/nygc.chr19
NORM_BASE=${UNNORM_BASE}.desegregated.normalized-directly-from-unnorm.grch38-ref.pansn.${SINGLE_REGION_FILE_BASE}

INPUT_GBWT=${UNNORM_BASE}.combined.gbwt #gets special treatment because of the ".combined." inclusion.

echo "${REGION_START} ${REGION_END}" >${SINGLE_REGION_FILE_BASE}.txt

# update the gbwt after the single snarl norm.
# nice time vg normalize -i ${SINGLE_REGION_FILE_BASE}.txt -g ${INPUT_GBWT} -r ${INPUT_GBWT}.gg -d ${UNNORM_BASE}.dist -o ${NORM_BASE}.gbwt ${UNNORM_BASE}.pg > ${NORM_BASE}.pg

#skip update gbwt
nice time vg normalize --skip_desegregate -i ${SINGLE_REGION_FILE_BASE}.txt -g ${INPUT_GBWT} -r ${INPUT_GBWT}.gg -d ${UNNORM_BASE}.dist -o ${NORM_BASE}.gbwt ${UNNORM_BASE}.pg > ${NORM_BASE}.pg