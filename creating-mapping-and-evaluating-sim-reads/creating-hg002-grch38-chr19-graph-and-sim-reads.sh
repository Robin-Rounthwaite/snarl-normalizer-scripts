#!/bin/bash
set -ex
cd /private/groups/patenlab/rrounthw/vg/
. ./source_me.sh
cd /private/groups/patenlab/rrounthw/nygc/chr19/sim-hg002-reads/

cp /private/home/hickey/dev/work/hprc-chm-hg002/hprc-chm-hg002-aug15.full.gbz .
vg convert -p hprc-chm-hg002-aug15.full.gbz > hprc-chm-hg002-aug15.full.pg

vg chunk -Cp CHM13#0#chr19 -x hprc-chm-hg002-aug15.full.pg > hprc-chm-hg002-aug15.full.chr19.pg
vg paths -x hprc-chm-hg002-aug15.full.chr19.pg -Q HG002#1 -F >hg002-chr19.paternal.fa
vg paths -x hprc-chm-hg002-aug15.full.chr19.pg -Q HG002#2 -F >hg002-chr19.maternal.fa

#clean off the trailing "#0" on all the fasta names:
sed s/#0// hg002-chr19.maternal.fa >hg002-chr19.maternal.fa
sed s/#0// hg002-chr19.paternal.fa >hg002-chr19.paternal.fa

#note: contents of ./chr19-hg002-seqfile.txt:
# GRCH38 chr19.fa
# HG002.1 hg002-chr19.paternal.fa
# hg002.2 hg002-chr19.maternal.fa
source /private/groups/cgl/cactus/venv-cactus-latest/bin/activate
rm -r js
cactus-pangenome ./js ./chr19-hg002-seqfile.txt --outDir ./chr19-hg002-graph/ --outName chr19-hg002 --reference GRCH38 --xg full clip --gbz full clip

cd /private/groups/patenlab/rrounthw/nygc/chr19/sim-hg002-reads/chr19-hg002-graph

#see which paths are on the graph. (to insert manually into the next command)
vg paths -Ev chr19-hg002.xg | sort

nice time vg sim --num-reads 1000000 --frag-len 500 --read-length 100 --random-seed 9999 --progress -x chr19-hg002.xg --align-out -P HG002#1#JAHKSE010000050.1#655 -P HG002#1#JAHKSE010000056.1#99 -P HG002#1#JAHKSE010000058.1#16 -P HG002#1#JAHKSE010000061.1#1298003 -P HG002#1#JAHKSE010000139.1#4636 -P hg002#2#JAHKSD010000015.1#1108 -P hg002#2#JAHKSD010000042.1#0 -P hg002#2#JAHKSD010000042.1#29382422 -P hg002#2#JAHKSD010000042.1#52728260 -P hg002#2#JAHKSD010000079.1#0 -P hg002#2#JAHKSD010000133.1#5264 -P hg002#2#JAHKSD010000195.1#6354 -P hg002#2#JAHKSD010000425.1#0 >/private/groups/patenlab/rrounthw/nygc/chr19/sim-hg002-reads/sim-1m-reads.chr19-hg002.gam


#outdated command that only inlcuded paternal hg002:
# nice time vg sim --num-reads 1000000 --frag-len 500 --read-length 100 --random-seed 9999 --progress -x chr19-hg002.xg --align-out -P HG002#1#JAHKSE010000050.1#655 -P HG002#1#JAHKSE010000056.1#99 -P HG002#1#JAHKSE010000058.1#16 -P HG002#1#JAHKSE010000061.1#1298003 -P HG002#1#JAHKSE010000139.1#4636 >/private/groups/patenlab/rrounthw/nygc/chr19/sim-hg002-reads/sim-1m-reads.chr19-hg002.gam

#I didn't include this in the original script, but I should have. I did it later. 
#Annotate the reads with the reference:
# TRUTH_GAM_BASE=/private/groups/patenlab/rrounthw/nygc/chr19/sim-hg002-reads/sim-1m-reads.chr19-hg002 #reads all simulated from full hg002 paths in chr21.
# TRUTH_GAM_GRAPH=/private/groups/patenlab/rrounthw/nygc/chr19/sim-hg002-reads/chr19-hg002-graph/chr19-hg002.xg
# vg annotate -m -x ${TRUTH_GAM_GRAPH} -t 20 -a ${TRUTH_GAM_BASE}.gam > ${TRUTH_GAM_BASE}.annotated.gam






HG002#1#JAHKSE010000050.1#655	19769499
HG002#1#JAHKSE010000056.1#99	8807267
HG002#1#JAHKSE010000058.1#16	16236060
HG002#1#JAHKSE010000061.1#1298003	9146007
HG002#1#JAHKSE010000139.1#4636	2904155
hg002#2#JAHKSD010000015.1#1108	946424
hg002#2#JAHKSD010000042.1#0	25129638
hg002#2#JAHKSD010000042.1#29382422	23329809
hg002#2#JAHKSD010000042.1#52728260	3985928
hg002#2#JAHKSD010000079.1#0	2895175
hg002#2#JAHKSD010000133.1#5264	703065
hg002#2#JAHKSD010000195.1#6354	53252
hg002#2#JAHKSD010000425.1#0	26954
