#!/bin/bash
set -ex
cd /private/groups/patenlab/rrounthw/nygc/chr21/

# location of Glenn's hg002 graph: (the "full" graph contains the centromeres of hg002, whereas the other does not). (don't need to copy because Glenn gave me the path names I need.)
cp /private/home/hickey/dev/work/hprc-chm-hg002/hprc-chm-hg002-aug15.full.gbz .

# convert to xg (no longer necessary since Glenn told me which paths I needed to use.)
vg convert -x hprc-chm-hg002-aug15.full.gbz > hprc-chm-hg002-aug15.full.xg

# extract chr21 component (no longer necessary since Glenn told me which paths I needed to use.)
vg chunk -x hprc-chm-hg002-aug15.full.xg -Cp CHM13#0#chr21 > hprc-chm-hg002-aug15.full.chr21.vg

#see which paths are on the graph.
vg paths -Ev hprc-chm-hg002-aug15.full.chr21.vg -Q HG002 | sort

# simulate 1m reads from hg002 paths
vg sim --num-reads 1000000 --frag-len 500 --read-length 100 --random-seed 9999 --progress -x hprc-chm-hg002-aug15.full.chr21.vg --align-out -P HG002#1#JAHKSE010000014.1#0 -P HG002#1#JAHKSE010000085.1#0 -P HG002#1#JAHKSE010000534.1#0 -P HG002#2#JAHKSD010000028.1#0 -P HG002#2#JAHKSD010000059.1#0 -P HG002#2#JAHKSD010000164.1#0 >sim-1m-hg002-chr21-reads.hprc-chm-hg002-aug15.full.gam
# below should work in theory, isn't working right now:
# vg sim --num-reads 1000000 --frag-len 500 --read-length 100 --random-seed 9999 --progress -x /private/home/hickey/dev/work/hprc-chm-hg002/hprc-chm-hg002-aug15.full.gbz --align-out -P HG002#1#JAHKSE010000014.1#0 -P HG002#1#JAHKSE010000085.1#0 -P HG002#1#JAHKSE010000534.1#0 -P HG002#2#JAHKSD010000028.1#0 -P HG002#2#JAHKSD010000059.1#0 -P HG002#2#JAHKSD010000164.1#0 >sim-1m-hg002-reads.hprc-chm-hg002-aug15.full.gam

#hg002 paths in chr21:
# HG002#1#JAHKSE010000014.1#0     34296955
# HG002#1#JAHKSE010000085.1#0     83011
# HG002#1#JAHKSE010000534.1#0     44556
# HG002#2#JAHKSD010000028.1#0     3574531
# HG002#2#JAHKSD010000059.1#0     34173178
# HG002#2#JAHKSD010000164.1#0     1296141
