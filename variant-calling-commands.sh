# for unnormalized
cd /public/groups/vg/rrounthw/jean-combined-sv-graph &&
nice vg mpmap -t 10 -x  hg38-hsvlr_srdedup17_aug.xg -n DNA -F GAM -g hg38-hsvlr_srdedup17_aug.gcsa -d hg38-hsvlr_srdedup17_aug.dist -G HG002-hg38-hsvlr_srdedup17_aug.giraffe29k11w32N_fast.gam > hg38-hsvlr_srdedup17_aug.mpmap.gam && echo “done with vg mpmap” &&
nice vg chunk -x hg38-hsvlr_srdedup17_aug.xg -a hg38-hsvlr_srdedup17_aug.mpmap.gam -g -p chr6 -b hg38-hsvlr_srdedup17_aug.normalized -O pg -t 10 > hg38-hsvlr_srdedup17_aug.chr6.pg && echo “done with vg chunk” &&
ls -alt && echo "done with ls" &&
mv hg38-hsvlr_srdedup17_aug.normalized_chr6.gam hg38-hsvlr_srdedup17_aug.chr6.mpmap.gam && echo "done with mv" &&
nice vg snarls hg38-hsvlr_srdedup17_aug.chr6.pg > hg38-hsvlr_srdedup17_aug.chr6.snarls.pb && echo "done with vg snarls" &&
nice vg pack -t 10 -x hg38-hsvlr_srdedup17_aug.chr6.pg -g hg38-hsvlr_srdedup17_aug.chr6.mpmap.gam -o hg38-hsvlr_srdedup17_aug.chr6.pack && echo " done with vg pack" &&
nice vg call -t 10 hg38-hsvlr_srdedup17_aug.chr6.pg -r hg38-hsvlr_srdedup17_aug.chr6.snarls.pb -k hg38-hsvlr_srdedup17_aug.chr6.pack -s hg38-hsvlr_srdedup17_aug.chr6.mpmap.gam > hg38-hsvlr_srdedup17_aug.chr6.variant_calls.vcf && echo "done with vg call"



# for normalized
cd /public/groups/vg/rrounthw/jean-combined-sv-graph &&
nice vg index -x hg38-hsvlr_srdedup17_aug.normalized.xg -g hg38-hsvlr_srdedup17_aug.normalized.gcsa -j hg38-hsvlr_srdedup17_aug.normalized.dist hg38-hsvlr_srdedup17_aug.normalized.vg && echo “done with vg index” &&
nice vg mpmap -t 10 -x  hg38-hsvlr_srdedup17_aug.normalized.xg -n DNA -F GAM -g hg38-hsvlr_srdedup17_aug.normalized.gcsa -d hg38-hsvlr_srdedup17_aug.normalized.dist -G HG002-hg38-hsvlr_srdedup17_aug.giraffe29k11w32N_fast.gam > hg38-hsvlr_srdedup17_aug.normalized.mpmap.gam && echo “done with vg mpmap” &&
nice vg chunk -x hg38-hsvlr_srdedup17_aug.normalized.xg -a hg38-hsvlr_srdedup17_aug.normalized.mpmap.gam -g -p chr6 -b hg38-hsvlr_srdedup17_aug.normalized -O pg -t 10 > hg38-hsvlr_srdedup17_aug.normalized.chr6.pg && echo “done with vg chunk” &&
ls -alt && echo "done with ls" &&
mv hg38-hsvlr_srdedup17_aug.normalized_chr6.gam hg38-hsvlr_srdedup17_aug.normalized.chr6.mpmap.gam && echo "done with mv" &&
nice vg snarls hg38-hsvlr_srdedup17_aug.normalized.chr6.pg > hg38-hsvlr_srdedup17_aug.normalized.chr6.snarls.pb && echo "done with vg snarls" &&
nice vg pack -t 10 -x hg38-hsvlr_srdedup17_aug.normalized.chr6.pg -g hg38-hsvlr_srdedup17_aug.normalized.chr6.mpmap.gam -o hg38-hsvlr_srdedup17_aug.normalized.chr6.pack && echo " done with vg pack" &&
nice vg call -t 10 hg38-hsvlr_srdedup17_aug.normalized.chr6.pg -r hg38-hsvlr_srdedup17_aug.normalized.chr6.snarls.pb -k hg38-hsvlr_srdedup17_aug.normalized.chr6.pack -s hg38-hsvlr_srdedup17_aug.normalized.chr6.mpmap.gam > hg38-hsvlr_srdedup17_aug.normalized.chr6.variant_calls.vcf && echo "done with vg call”

#After this, all I need to do is move both vcfs into the folder labeled vcf, and start Jean's docker container!
#https://github.com/jmonlong/sveval/blob/master/snakemake/README.md#example-evaluating-svs-on-grch37-agains-the-giab-sv-truthset 