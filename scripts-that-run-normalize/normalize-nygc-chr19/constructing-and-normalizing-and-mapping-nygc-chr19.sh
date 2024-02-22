#!/bin/bash
set -ex
cd /private/groups/patenlab/rrounthw/vg/
# git checkout master
git pull
. ./source_me.sh && make -j 20
cd /private/groups/patenlab/rrounthw/nygc/chr19/chr19-from-scratch

# vg construct -a -r chr19.fa -v ../CCDG_14151_B01_GRM_WGS_2020-08-05_chr19.filtered.shapeit2-duohmm-phased.vcf.gz > nygc.chr19.vg

# vg stats -F nygc.chr19.vg # to see if it's a pg.

# vg convert -p nygc.chr19.vg > nygc.chr19.pg

# # wget https://storage.googleapis.com/cmarkell-vg-wdl-dev/giraffe_manuscript_data/genome_references/graph_references/1000gp_data_nygc_phased/CCDG_14151_B01_GRM_WGS_2020-08-05_chr19.filtered.shapeit2-duohmm-phased.vcf.gz

# # wget https://storage.googleapis.com/cmarkell-vg-wdl-dev/giraffe_manuscript_data/genome_references/graph_references/1000gp_data_nygc_phased/CCDG_14151_B01_GRM_WGS_2020-08-05_chr19.filtered.shapeit2-duohmm-phased.vcf.gz.tbi

# # Prepare the GBWT of haplotypes
# nice time vg gbwt -x nygc.chr19.pg -v ../CCDG_14151_B01_GRM_WGS_2020-08-05_chr19.filtered.shapeit2-duohmm-phased.vcf.gz -o nygc.chr19.variants.gbwt

# # Prepare an additional GBWT of the graph's embedded paths
# nice time vg gbwt -x nygc.chr19.pg -E -o nygc.chr19.paths.gbwt

# # Combine into one GBWT
# nice time vg gbwt -m nygc.chr19.variants.gbwt nygc.chr19.paths.gbwt -o nygc.chr19.combined.gbwt

# # Make the gbwt graph
# nice time vg gbwt -g nygc.chr19.combined.gbwt.gg -x nygc.chr19.pg nygc.chr19.combined.gbwt

# # #todo: check to see if the gbwt has the reference path chr19 that I want.
# nice time vg paths -Lg nygc.chr19.combined.gbwt > nygc.chr19.combined.gbwt.paths.txt

# nice time vg index -j nygc.chr19.dist nygc.chr19.pg



#test/debug normalize run:
# UNNORM_BASE=nygc.chr19 && SEGREGATED_BASE=${UNNORM_BASE}.segregated-regions && NORM_BASE=${UNNORM_BASE}.desegregated.normalized && INPUT_GBWT=${UNNORM_BASE}.combined.gbwt && cd ~/paten_lab/vg-team/vg/ && . ./source_me.sh && make -j 20 &&  cd ~/paten_lab/vg-team/vg/robin-graphs/nygc-chr19 && nice time vg normalize --run_tests --skip_desegregate -t 1 -g ${SEGREGATED_BASE}.gbwt -r ${SEGREGATED_BASE}.gbwt.gg -d ${UNNORM_BASE}.dist -S /home/robin/paten_lab/vg-team/vg/robin-scripts/scratch/chr19-snarls-that-take-a-long-time.made-into-segregated-regions.txt -o ${NORM_BASE}.gbwt ${SEGREGATED_BASE}.pg > ${NORM_BASE}.skip-desegregate.pg 2> test-stderr-3.txt


#### normalize
UNNORM_BASE=nygc.chr19
SEGREGATED_BASE=${UNNORM_BASE}.segregated-regions
NORM_BASE=${UNNORM_BASE}.desegregated.normalized

INPUT_GBWT=${UNNORM_BASE}.combined.gbwt #gets special treatment because of the ".combined." inclusion.

#make the segregated-regions graph.
# nice time vg normalize -g ${INPUT_GBWT} -r ${INPUT_GBWT}.gg -d ${UNNORM_BASE}.dist -s ${SEGREGATED_BASE}.data.txt -o ${SEGREGATED_BASE}.gbwt ${UNNORM_BASE}.pg > ${SEGREGATED_BASE}.pg

#create the gbwt graph:
# nice time vg gbwt -g ${SEGREGATED_BASE}.gbwt.gg -x ${SEGREGATED_BASE}.pg ${SEGREGATED_BASE}.gbwt

#normalize the segregated-regions graph.``
# nice time vg normalize --run_tests -t 20 -g ${SEGREGATED_BASE}.gbwt -r ${SEGREGATED_BASE}.gbwt.gg -d ${UNNORM_BASE}.dist -S ${SEGREGATED_BASE}.data.txt -o ${NORM_BASE}.gbwt ${SEGREGATED_BASE}.pg > ${NORM_BASE}.pg

####for debuggging:
# nice time vg normalize --run_tests --skip_desegregate -t 20 -g ${SEGREGATED_BASE}.gbwt -r ${SEGREGATED_BASE}.gbwt.gg -d ${UNNORM_BASE}.dist -S ${SEGREGATED_BASE}.data.txt -o ${NORM_BASE}.gbwt ${SEGREGATED_BASE}.pg > ${NORM_BASE}.skip-desegregate.pg
#for skip_desegregate:
# UNNORM_BASE=nygc.chr19 && SEGREGATED_BASE=${UNNORM_BASE}.segregated-regions && NORM_BASE=${UNNORM_BASE}.desegregated.normalized && INPUT_GBWT=${UNNORM_BASE}.combined.gbwt && nice time vg normalize --skip_desegregate --run_tests -t 20 -g ${SEGREGATED_BASE}.gbwt -r ${SEGREGATED_BASE}.gbwt.gg -d ${UNNORM_BASE}.dist -S ${SEGREGATED_BASE}.data.txt -o ${NORM_BASE}.gbwt ${SEGREGATED_BASE}.pg > ${NORM_BASE}.skip-desegregate.pg
####end debugging.

#### get the necessary giraffe input files:
##generate giraffe .gbwt and gg 
#unnorm:
nice time vg gbwt -l -x ${UNNORM_BASE}.pg -o ${UNNORM_BASE}.giraffe.gbwt ${INPUT_GBWT}
nice time vg gbwt -g ${UNNORM_BASE}.giraffe.gbwt.gg -x ${UNNORM_BASE}.pg ${UNNORM_BASE}.giraffe.gbwt

#norm:
nice time vg gbwt -l -x ${NORM_BASE}.pg -o ${NORM_BASE}.giraffe.gbwt ${NORM_BASE}.gbwt
nice time vg gbwt -g ${NORM_BASE}.giraffe.gbwt.gg -x ${NORM_BASE}.pg ${NORM_BASE}.giraffe.gbwt

##generate normalized .dist
nice time vg index -j ${NORM_BASE}.dist ${NORM_BASE}.pg

##generate .min
#unnorm:
nice time vg minimizer -g ${UNNORM_BASE}.giraffe.gbwt -d ${UNNORM_BASE}.dist -o ${UNNORM_BASE}.min ${UNNORM_BASE}.pg
#norm:
nice time vg minimizer -g ${NORM_BASE}.giraffe.gbwt -d ${NORM_BASE}.dist -o ${NORM_BASE}.min ${NORM_BASE}.pg

#### simulate reads from hg002 version of the graph.
#already done in /home/robin/paten_lab/vg-team/vg/robin-scripts/creating-mapping-and-evaluating-sim-reads/creating-hg002-grch38-chr19-graph-and-sim-reads.sh

#### mapping experiment. (from /home/robin/paten_lab/vg-team/vg/robin-scripts/mapping-and-evaluating-sim-reads/giraffe-mapping-and-evaluation-of-sim-reads-on-normalize.sh)
TRUTH_GAM=/private/groups/patenlab/rrounthw/nygc/chr19/sim-hg002-reads/sim-1m-reads.chr19-hg002.gam #reads all simulated from full hg002 paths in chr21.

READ_METADATA=1m-hg002-chr19-reads
NORM_GAM=${NORM_BASE}.${READ_METADATA}.gam
UNNORM_GAM=${UNNORM_BASE}.${READ_METADATA}.gam

##run giraffe
#unnnormalized
nice time vg giraffe -m ${UNNORM_BASE}.min -d ${UNNORM_BASE}.dist -g ${UNNORM_BASE}.giraffe.gbwt.gg -H ${UNNORM_BASE}.giraffe.gbwt -i -G ${TRUTH_GAM} -p -t 22 > ${UNNORM_GAM} &&
#normalized
nice time vg giraffe -m ${NORM_BASE}.min -d ${NORM_BASE}.dist -g ${NORM_BASE}.giraffe.gbwt.gg -H ${NORM_BASE}.giraffe.gbwt -i -G ${TRUTH_GAM} -p -t 22 > ${UNNORM_GAM} &&

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
KEYWORD=${UNNORM_BASE}.hg002
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
get_roc_stats ${TRUTH_GAM} ${UNNORM_GAM} graph.pg ${REPORT} ${ROC_STATS} unnormalized ${KEYWORD}&&

GBWT=norm-gbwt
#make the summary stats for normalized
get_roc_stats ${TRUTH_GAM} ${NORM_GAM} graph.combined.n32.desegregated-regions.normalized.pg ${REPORT} ${ROC_STATS} normalized ${KEYWORD}&&
sed -i 's/null/-1/g' ${ROC_STATS} #turn nulls into -1 so that they don't mess up the plot-qq/plot-roc.
gzip -f ${ROC_STATS}

