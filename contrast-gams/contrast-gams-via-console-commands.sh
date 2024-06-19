#!/bin/bash
set -ex
set -o pipefail
cd /private/groups/patenlab/rrounthw/vg/
git pull
. ./source_me.sh && make -j 20
# . ./source_me.sh
cd /private/groups/patenlab/rrounthw/nygc/chr19/chr19-from-scratch


###always make 1=unnormalized and 2=normalized
##truth gam:
READ_METADATA=sim-6m-hg002-chr19-reads
GAM_TRUTH=/private/groups/patenlab/rrounthw/nygc/chr19/sim-hg002-reads/${READ_METADATA}.annotated.gam
##input:
#GAMS
GAM_1_BASE=nygc.chr19.${READ_METADATA}
GAM_2_BASE=nygc.chr19.desegregated.normalized-directly-from-unnorm.${READ_METADATA}
GAM_1=${GAM_1_BASE}.gam
GAM_2=${GAM_2_BASE}.gam
#GRAPHS
GRAPH_1=nygc.chr19.grch38-ref.pansn.pg
GRAPH_2=nygc.chr19.desegregated.normalized-directly-from-unnorm.grch38-ref.pansn.pg

##output from gamcompare:
OUTPUT_DIR=solo-compared
mkdir -p ${OUTPUT_DIR}
GAM_1_ANNOTATED=${OUTPUT_DIR}/${GAM_1_BASE}.annotated.gam
GAM_2_ANNOTATED=${OUTPUT_DIR}/${GAM_2_BASE}.annotated.gam
GAM_1_COMPARED=${OUTPUT_DIR}/${GAM_1_BASE}.solo-compared.gam
GAM_2_COMPARED=${OUTPUT_DIR}/${GAM_2_BASE}.solo-compared.gam
GAM_1_COUNT=${GAM_1_COMPARED}.count
GAM_2_COUNT=${GAM_2_COMPARED}.count

GAM_1_COMPARED_JSON=/private/groups/patenlab/rrounthw/nygc/chr19/chr19-from-scratch/unnormalized.nygc.chr19.sim-6m-hg002-chr19-reads.grch38-ref.pansn.compared.json
GAM_2_COMPARED_JSON=/private/groups/patenlab/rrounthw/nygc/chr19/chr19-from-scratch/normalized.nygc.chr19.sim-6m-hg002-chr19-reads.grch38-ref.pansn.compared.json

#note: this doesn't get ran unless you call the function, of course.
get_individual_gamcompare () 
{
    #input:
    TRUTH=$1 # this is the truth set gam (e.g. reads.gam), i.e. the gam the simulated reads came in.
    MAPPED=$2 # the re-mapped reads (e.g. mapped.gam) that we'll be scoring.
    GRAPH=$3 # the graph we mapped the reads to.
    #output:
    ANNOTATED=$4 #the gam that is compared to the truth set, so it has markings for accuracy.
    COMPARED=$5 #the gam that is compared to the truth set, so it has markings for accuracy.
    JSON=$6
    COUNT=$7 #gives various stats for reads after gamcompare.
    
    vg gamcompare -r 100 -s <(vg annotate -m -x ${GRAPH} -a ${MAPPED}) ${TRUTH} 2>${COUNT} >${COMPARED}
    
    # vg view -aj ${COMPARED} > ${JSON}
}

# get_individual_gamcompare ${GAM_TRUTH} ${GAM_1} ${GRAPH_1} ${GAM_1_ANNOTATED} ${GAM_1_COMPARED} ${GAM_1_COMPARED_JSON} ${GAM_1_COUNT}
# get_individual_gamcompare ${GAM_TRUTH} ${GAM_2} ${GRAPH_2} ${GAM_2_ANNOTATED} ${GAM_2_COMPARED} ${GAM_2_COMPARED_JSON} ${GAM_2_COUNT}

cd ${OUTPUT_DIR}

# # Get the names of all reads on compared-1.gam that are mapped correctly at high MAPQ
# jq -r 'select(.correctly_mapped) | select((.mapping_quality // 0) > 50) | .name' ${GAM_1_COMPARED_JSON} | sort > correct-high-mapq-1.tsv

# # Get the names of all reads in compared-2.gam that are mapped correctly at high MAPQ
# jq -r 'select(.correctly_mapped) | select((.mapping_quality // 0) > 50) | .name' ${GAM_2_COMPARED_JSON} | sort > correct-high-mapq-2.tsv


###experiment: correct-high-mapq.second-only.from-second
# # Get all the reads that are in the second set but not the first set
# comm -1 -3 correct-high-mapq-1.tsv correct-high-mapq-2.tsv > correct-high-mapq.second-only.tsv

# # # Get the mappings for those reads
# vg filter --exact-name -N correct-high-mapq.second-only.tsv ../${GAM_2_COMPARED} >correct-high-mapq.second-only.from-second.gam

# # Get their first reference position coordinates (for those that have them)
# vg view -aj correct-high-mapq.second-only.from-second.gam | jq -r 'select(.refpos) | .refpos[0].offset' >correct-high-mapq.second-only.from-second.tsv

# sed -i '/null/d' correct-high-mapq.second-only.from-second.tsv #deletes nulls

# # Plot a histogram of those positions (assuming that they are all on the same chromosome)
# ./histogram.py correct-high-mapq.second-only.from-second.tsv --bins 100 --x_min 0 --x_max 62000000 --x_label "Position (bp)" --y_label "Reads" --title "Chr19 reads on norm, >mapq 50, gain accuracy" --save correct-high-mapq.second-only.from-second.png









# #####experiment: correct-high-mapq.first-only.from-second
# # Get all the reads that are in the first set but not the second set
# comm -2 -3 correct-high-mapq-1.tsv correct-high-mapq-2.tsv > correct-high-mapq.firstonly.tsv

# # # Get the mappings for those reads from the second set
# vg filter --exact-name -N correct-high-mapq.firstonly.tsv ../${GAM_2_COMPARED} >correct-high-mapq.first-only.from-second.gam

# #####Note: this ends the sh because of head returning a message (I think).
# ##### # Find out the top 5 contigs their first reference positions tend to be on
# ##### vg view -aj correct-high-mapq.first-only.from-second.gam | jq -r 'select(.refpos) | .refpos[0].name' | sort | uniq -c | sort -r -n | head -n5

# # Get their first reference position coordinates (for those that have them)
# vg view -aj correct-high-mapq.first-only.from-second.gam | jq -r 'select(.refpos) | .refpos[0].offset' >correct-high-mapq.first-only.from-second.tsv

# sed -i '/null/d' correct-high-mapq.first-only.from-second.tsv #deletes nulls

# # # Grab a histogram script
# # wget https://gist.githubusercontent.com/adamnovak/8d31f53d16a33f847d9c/raw/b723272cf72d5cf0b822d71a236a1e6d242d188f/histogram.py
# # chmod +x histogram.py
# # pip install matplotlib

# # Plot a histogram of those positions (assuming that they are all on the same chromosome)
# # ./histogram.py correct-high-mapq.first-only.from-second.tsv --x_label "Position (bp)" --y_label "Reads" --title "Chr19 reads >mapq 50 that change to lose accuracy in norm graph." --save correct-high-mapq.first-only.from-second.png

# # ./histogram.py correct-high-mapq.first-only.from-second.tsv --x_label "Position (bp)" --y_label "Reads" --title "Chr19 reads on norm, >mapq 50, lose accuracy" --save correct-high-mapq.first-only.from-second.png

# ./histogram.py correct-high-mapq.first-only.from-second.tsv --bins 100 --x_min 0 --x_max 62000000 --x_label "Position (bp)" --y_label "Reads" --title "Chr19 reads on norm, >mapq 50, lose accuracy" --save correct-high-mapq.first-only.from-second.png



#######June 19th 2024 - Experiment that gets reads from acc -> unacc when normalized. Visualize histogram for positions on unnormalized graph.
#######( therefore, high-mapq-correct-to-incorrect.unnorm-only.unnorm-position)
# #(from a previous run):
# # Get all the reads that are in the first set but not the second set
# comm -2 -3 correct-high-mapq-1.tsv correct-high-mapq-2.tsv > correct-high-mapq.firstonly.tsv

EXPERIMENT_NAME=high-mapq-correct-to-incorrect.unnorm-only.unnorm-position

# Get the mappings for those reads from the first set
vg filter --exact-name -N correct-high-mapq.firstonly.tsv ../${GAM_1_COMPARED} >${EXPERIMENT_NAME}.gam

# Get their first reference position coordinates (for those that have them)
vg view -aj ${EXPERIMENT_NAME}.gam | jq -r 'select(.refpos) | .refpos[0].offset' >${EXPERIMENT_NAME}.tsv

sed -i '/null/d' ${EXPERIMENT_NAME}.tsv #deletes nulls

./histogram.py ${EXPERIMENT_NAME}.tsv --bins 100 --x_min 0 --x_max 62000000 --x_label "Position (bp)" --y_label "Reads" --title "Chr19 reads on norm, >mapq 50, lose accuracy" --save ${EXPERIMENT_NAME}.png





# -------------- junk
# vg view -aj correct-high-mapq.first-only.from-second.gam | jq -r 'select(.refpos) | .refpos[0].name' | sort | uniq -c | sort -r -n | head -n5


# refpos[0].offset>something and <

# jq select


# pull reads, look at them via
# tubemap 
# + dot visualization for look at graph

