# for unnormalized
cd /public/groups/vg/rrounthw/jean-combined-sv-graph &&
# nice vg index -j hg38-hsvlr_srdedup17_aug.new.dist hg38-hsvlr_srdedup17_aug.vg
nice vg mpmap -t 10 -x hg38-hsvlr_srdedup17_aug.xg -n DNA -F GAM -g hg38-hsvlr_srdedup17_aug.gcsa -d hg38-hsvlr_srdedup17_aug.new.dist -G HG002-hg38-hsvlr_srdedup17_aug.giraffe29k11w32N_fast.gam > hg38-hsvlr_srdedup17_aug.mpmap.gam && echo “done with vg mpmap” &&
nice vg chunk -x hg38-hsvlr_srdedup17_aug.xg -a hg38-hsvlr_srdedup17_aug.mpmap.gam -g -p chr6 -b hg38-hsvlr_srdedup17_aug.normalized -O pg -t 10 > hg38-hsvlr_srdedup17_aug.chr6.pg && echo “done with vg chunk” &&
ls -alt && echo "done with ls" &&
mv hg38-hsvlr_srdedup17_aug.normalized_chr6.gam hg38-hsvlr_srdedup17_aug.chr6.mpmap.gam && echo "done with mv" &&
nice vg snarls hg38-hsvlr_srdedup17_aug.chr6.pg > hg38-hsvlr_srdedup17_aug.chr6.snarls.pb && echo "done with vg snarls" &&
nice vg pack -t 10 -x hg38-hsvlr_srdedup17_aug.chr6.pg -g hg38-hsvlr_srdedup17_aug.chr6.mpmap.gam -o hg38-hsvlr_srdedup17_aug.chr6.pack && echo " done with vg pack" &&
nice vg call -t 10 hg38-hsvlr_srdedup17_aug.chr6.pg -r hg38-hsvlr_srdedup17_aug.chr6.snarls.pb -k hg38-hsvlr_srdedup17_aug.chr6.pack -s hg38-hsvlr_srdedup17_aug.chr6.mpmap.gam > hg38-hsvlr_srdedup17_aug.chr6.variant_calls.vcf && echo "done with vg call"



# for normalized
# I need to prune the graph before making the gcsa.
#todo: Also, do I need to index each chromosome individually?
cd /public/groups/vg/rrounthw/jean-combined-sv-graph &&
# nice vg index -x hg38-hsvlr_srdedup17_aug.normalized.xg -j hg38-hsvlr_srdedup17_aug.normalized.dist hg38-hsvlr_srdedup17_aug.normalized.vg && echo “done with vg index non-gcsa” &&
# nice vg paths -r -p refpaths.txt -v hg38-hsvlr_srdedup17_aug.normalized.vg | nice vg prune -t 16 -M 32 --restore-paths - > hg38-hsvlr_srdedup17_aug.normalized.pruned.vg && echo "done with prune" &&
# nice vg convert -p hg38-hsvlr_srdedup17_aug.normalized.vg > hg38-hsvlr_srdedup17_aug.normalized.pg && echo "done with convert" &&
# mkdir hg38-hsvlr_srdedup17_aug.normalized.pruned.chunks/ &&
nice vg chunk -C -P refpaths.txt -b hg38-hsvlr_srdedup17_aug.normalized.pruned.chunks/chunk_ -x hg38-hsvlr_srdedup17_aug.normalized.pg && echo "done with chunk" &&
cd hg38-hsvlr_srdedup17_aug.normalized.pruned.chunks/ &&
ls -alt &&
for i in $(seq 1 22; echo X; echo Y); do
    nice vg paths -d -Q chr${i}_ -v chunk__chr${i}.vg | nice vg prune -t 10 -M 32 --restore-paths - > chunk_chr${i}.pruned.vg && echo "pruned chunk_chr{i}.vg"
done && echo "done with prunes" &&
nice vg paths -L -v chunk_chr6.pruned.vg && echo "done with looking at paths from chr6 chunk" &&
ls -alt && echo "done with ls" &&
nice vg index -g ../hg38-hsvlr_srdedup17_aug.normalized.gcsa $(for i in $(seq 22; echo X; echo Y); do echo chunk_chr${i}.pruned.vg; done) && echo "done with indexing gcsa" &&
ls -alt && echo "done with ls" &&
cd .. && echo "done with cd .." &&
ls -alt && echo "done with ls" &&
nice vg mpmap -t 10 -x  hg38-hsvlr_srdedup17_aug.normalized.xg -n DNA -F GAM -g hg38-hsvlr_srdedup17_aug.normalized.gcsa -d hg38-hsvlr_srdedup17_aug.normalized.dist -G HG002-hg38-hsvlr_srdedup17_aug.giraffe29k11w32N_fast.gam > hg38-hsvlr_srdedup17_aug.normalized.mpmap.gam && echo “done with vg mpmap” &&
nice vg chunk -x hg38-hsvlr_srdedup17_aug.normalized.xg -a hg38-hsvlr_srdedup17_aug.normalized.mpmap.gam -g -p chr6 -b hg38-hsvlr_srdedup17_aug.normalized -O pg -t 10 > hg38-hsvlr_srdedup17_aug.normalized.chr6.pg && echo “done with vg chunk” &&
ls -alt && echo "done with ls" &&
mv hg38-hsvlr_srdedup17_aug.normalized_chr6.gam hg38-hsvlr_srdedup17_aug.normalized.chr6.mpmap.gam && echo "done with mv" &&
nice vg snarls hg38-hsvlr_srdedup17_aug.normalized.chr6.pg > hg38-hsvlr_srdedup17_aug.normalized.chr6.snarls.pb && echo "done with vg snarls" &&
nice vg pack -t 10 -x hg38-hsvlr_srdedup17_aug.normalized.chr6.pg -g hg38-hsvlr_srdedup17_aug.normalized.chr6.mpmap.gam -o hg38-hsvlr_srdedup17_aug.normalized.chr6.pack && echo " done with vg pack" &&
nice vg call -t 10 hg38-hsvlr_srdedup17_aug.normalized.chr6.pg -r hg38-hsvlr_srdedup17_aug.normalized.chr6.snarls.pb -k hg38-hsvlr_srdedup17_aug.normalized.chr6.pack -s hg38-hsvlr_srdedup17_aug.normalized.chr6.mpmap.gam > hg38-hsvlr_srdedup17_aug.normalized.chr6.variant_calls.vcf && echo "done with vg call"

#After this, all I need to do is move both vcfs into the folder labeled vcf, and start Jean's docker container!
#https://github.com/jmonlong/sveval/blob/master/snakemake/README.md#example-evaluating-svs-on-grch37-agains-the-giab-sv-truthset 

#todo: consider augmenting the graph with the reads.

# it is running on courtyard on screens 6 and 7.

# I made a pruned version of the full genome graph, but it didn't appear to keep any of the paths. I'm not sure what went wrong. That would interfere with the vg chunk, though. So I'm reversing the order. Chunk first, then prune.


# scratch:
# nice vg paths -d -Q {chr}_ -v {vg} | nice vg prune -t {threads} -M 32 --restore-paths - > pruned.vg
# nice vg convert -p hg38-hsvlr_srdedup17_aug.normalized.pruned.vg > hg38-hsvlr_srdedup17_aug.normalized.pruned.pg
# mkdir hg38-hsvlr_srdedup17_aug.normalized.chunks
# nice vg chunk -P refpaths.txt -b hg38-hsvlr_srdedup17_aug.normalized.pruned.chunks/
# nice vg index -g all.gcsa $(for i in $(seq 22; echo X; echo Y); do echo chr${i}.pruned.vg; done)
# nice vg index -g hg38-hsvlr_srdedup17_aug.normalized.gcsa hg38-hsvlr_srdedup17_aug.normalized.pruned.pg && echo “done with vg index gcsa” &&

# for i in $(seq 1 22; echo X; echo Y); do
#     # vg prune -u -a -m mapping chr${i}.vg > chr${i}.pruned.vg
#     echo {i}
# done &&
# echo hi &&
# #test
# #double test
# echo hi again



    # vg prune -u -a -m mapping chr${i}.vg > chr${i}.pruned.vg
