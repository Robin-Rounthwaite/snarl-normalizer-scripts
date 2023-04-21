I made this using Jean's pipeline:
https://github.com/jmonlong/sveval/blob/master/snakemake/README.md#example-evaluating-svs-on-grch37-agains-the-giab-sv-truthset

Using:
-rw-r--r--  1 rrounthw vg    106583844 Apr 19 17:12 hg38-hsvlr_srdedup17_aug.chr6.normalized.variant_calls.vcf
-rw-r--r--  1 rrounthw vg    109258281 Apr 19 17:10 hg38-hsvlr_srdedup17_aug.chr6.variant_calls.vcf

Generated with this series of commands:

mapping and variant calling commands for chr6 and full genome in courtyard
## chr6:
#non-normalized
nice vg mpmap -F GAM -t 16 -x hg38-hsvlr_srdedup17_aug.chr6.xg -g hg38-hsvlr_srdedup17_aug.chr6.gcsa -d hg38-hsvlr_srdedup17_aug.chr6.dist -s hg38-hsvlr_srdedup17_aug.chr6.snarls -G chunk_chr6.gam >hg38-hsvlr_srdedup17_aug.chr6.mpmap-aln.gam && echo “done with mpmap” &&
nice vg augment hg38-hsvlr_srdedup17_aug.chr6.pg hg38-hsvlr_srdedup17_aug.chr6.mpmap-aln.gam -m 4 -q 5 -Q 5 -A hg38-hsvlr_srdedup17_aug.chr6.mpmap-aln.aug.gam > hg38-hsvlr_srdedup17_aug.chr6.aug.pg && echo "done with vg augment" &&
nice vg snarls hg38-hsvlr_srdedup17_aug.chr6.aug.pg > hg38-hsvlr_srdedup17_aug.chr6.aug.snarls.pb && echo " done with vg snarls"  &&
nice vg pack -x hg38-hsvlr_srdedup17_aug.chr6.aug.pg -g hg38-hsvlr_srdedup17_aug.chr6.mpmap-aln.aug.gam -o hg38-hsvlr_srdedup17_aug.chr6.aug.pack && echo " done with vg pack"  &&
nice vg call hg38-hsvlr_srdedup17_aug.chr6.aug.pg -p chr6 -r hg38-hsvlr_srdedup17_aug.chr6.aug.snarls.pb -k hg38-hsvlr_srdedup17_aug.chr6.aug.pack -s chunk_chr6.gam > hg38-hsvlr_srdedup17_aug.chr6.variant_calls.vcf && echo " done with vg call" 

#normalized:
nice vg mpmap -F GAM -t 16 -x hg38-hsvlr_srdedup17_aug.chr6.normalized.xg -g hg38-hsvlr_srdedup17_aug.chr6.normalized.gcsa -d hg38-hsvlr_srdedup17_aug.chr6.normalized.dist -s hg38-hsvlr_srdedup17_aug.chr6.normalized.snarls -G chunk_chr6.gam >hg38-hsvlr_srdedup17_aug.chr6.normalized.mpmap-aln.gam && echo “done with mpmap” &&
nice vg augment hg38-hsvlr_srdedup17_aug.chr6.normalized.pg hg38-hsvlr_srdedup17_aug.chr6.normalized.mpmap-aln.gam -m 4 -q 5 -Q 5 -A hg38-hsvlr_srdedup17_aug.chr6.normalized.mpmap-aln.aug.gam > hg38-hsvlr_srdedup17_aug.chr6.normalized.aug.pg && echo "done with vg augment" &&
nice vg snarls hg38-hsvlr_srdedup17_aug.chr6.normalized.aug.pg > hg38-hsvlr_srdedup17_aug.chr6.normalized.aug.snarls.pb && echo " done with vg snarls"  &&
nice vg pack -x hg38-hsvlr_srdedup17_aug.chr6.normalized.aug.pg -g hg38-hsvlr_srdedup17_aug.chr6.normalized.mpmap-aln.aug.gam -o hg38-hsvlr_srdedup17_aug.chr6.normalized.aug.pack && echo " done with vg pack"  &&
nice vg call hg38-hsvlr_srdedup17_aug.chr6.normalized.aug.pg -p chr6 -r hg38-hsvlr_srdedup17_aug.chr6.normalized.aug.snarls.pb -k hg38-hsvlr_srdedup17_aug.chr6.normalized.aug.pack -s chunk_chr6.gam > hg38-hsvlr_srdedup17_aug.chr6.normalized.variant_calls.vcf && echo " done with vg call"

(And I plan to use:)

## Full genome:
#non-normalized
nice vg convert -p hg38-hsvlr_srdedup17_aug.xg > hg38-hsvlr_srdedup17_aug.pg && echo "done with convert" &&
nice vg paths -r -p refpaths.txt -v hg38-hsvlr_srdedup17_aug.pg | nice vg prune -t 16 -M 32 --restore-paths - > hg38-hsvlr_srdedup17_aug.pruned.pg && echo "done with vg prune" &&
nice vg index -g hg38-hsvlr_srdedup17_aug.new.gcsa hg38-hsvlr_srdedup17_aug.pruned.xg && echo "done with index gcsa" &&
nice vg index -j hg38-hsvlr_srdedup17_aug.new.dist hg38-hsvlr_srdedup17_aug.xg && echo "done with index dist" &&
nice vg mpmap -F GAM -t 16 -x hg38-hsvlr_srdedup17_aug.xg -g hg38-hsvlr_srdedup17_aug.new.gcsa -d hg38-hsvlr_srdedup17_aug.new.dist -s hg38-hsvlr_srdedup17_aug.snarls -G HG002-hg38-hsvlr_srdedup17_aug.giraffe29k11w32N_fast.gam >hg38-hsvlr_srdedup17_aug.mpmap-aln.gam && echo “done with mpmap” &&
nice vg augment hg38-hsvlr_srdedup17_aug.pg hg38-hsvlr_srdedup17_aug.mpmap-aln.gam -m 4 -q 5 -Q 5 -A hg38-hsvlr_srdedup17_aug.mpmap-aln.aug.gam > hg38-hsvlr_srdedup17_aug.aug.pg && echo "done with vg augment" &&
nice vg snarls hg38-hsvlr_srdedup17_aug.aug.pg > hg38-hsvlr_srdedup17_aug.aug.snarls.pb && echo " done with vg snarls"  &&
nice vg pack -x hg38-hsvlr_srdedup17_aug.aug.pg -g hg38-hsvlr_srdedup17_aug.mpmap-aln.aug.gam -o hg38-hsvlr_srdedup17_aug.aug.pack && echo " done with vg pack"  &&
nice vg call hg38-hsvlr_srdedup17_aug.aug.pg -r hg38-hsvlr_srdedup17_aug.aug.snarls.pb -k hg38-hsvlr_srdedup17_aug.aug.pack -s chunk_chr6.gam > hg38-hsvlr_srdedup17_aug.variant_calls.vcf && echo " done with vg call" 

#normalized
nice vg convert -p hg38-hsvlr_srdedup17_aug.normalized.vg > hg38-hsvlr_srdedup17_aug.normalized.pg && echo "done with convert" &&
nice vg convert -x hg38-hsvlr_srdedup17_aug.normalized.pg > hg38-hsvlr_srdedup17_aug.normalized.xg && echo "done with convert" &&
nice vg paths -r -p refpaths.txt -v hg38-hsvlr_srdedup17_aug.normalized.pg | nice vg prune -t 16 -M 32 --restore-paths - > hg38-hsvlr_srdedup17_aug.normalized.pruned.pg && echo "done with vg prune" &&
nice vg index -g hg38-hsvlr_srdedup17_aug.normalized.gcsa hg38-hsvlr_srdedup17_aug.normalized.pruned.xg && echo "done with index gcsa" &&
nice vg index -j hg38-hsvlr_srdedup17_aug.normalized.dist hg38-hsvlr_srdedup17_aug.normalized.xg && echo "done with index dist" &&
nice vg mpmap -F GAM -t 16 -x hg38-hsvlr_srdedup17_aug.normalized.xg -g hg38-hsvlr_srdedup17_aug.normalized.gcsa -d hg38-hsvlr_srdedup17_aug.normalized.dist -s hg38-hsvlr_srdedup17_aug.normalized.snarls -G HG002-hg38-hsvlr_srdedup17_aug.giraffe29k11w32N_fast.gam >hg38-hsvlr_srdedup17_aug.normalized.mpmap-aln.gam && echo “done with mpmap” &&
nice vg augment hg38-hsvlr_srdedup17_aug.normalized.pg hg38-hsvlr_srdedup17_aug.normalized.mpmap-aln.gam -m 4 -q 5 -Q 5 -A hg38-hsvlr_srdedup17_aug.normalized.mpmap-aln.aug.gam > hg38-hsvlr_srdedup17_aug.normalized.aug.pg && echo "done with vg augment" &&
nice vg snarls hg38-hsvlr_srdedup17_aug.normalized.aug.pg > hg38-hsvlr_srdedup17_aug.normalized.aug.snarls.pb && echo " done with vg snarls"  &&
nice vg pack -x hg38-hsvlr_srdedup17_aug.normalized.aug.pg -g hg38-hsvlr_srdedup17_aug.normalized.mpmap-aln.aug.gam -o hg38-hsvlr_srdedup17_aug.normalized.aug.pack && echo " done with vg pack"  &&
nice vg call hg38-hsvlr_srdedup17_aug.normalized.aug.pg -r hg38-hsvlr_srdedup17_aug.normalized.aug.snarls.pb -k hg38-hsvlr_srdedup17_aug.normalized.aug.pack -s chunk_chr6.gam > hg38-hsvlr_srdedup17_aug.normalized.variant_calls.vcf && echo " done with vg call" 



(notes original location: /home/robin/paten_lab/vg-team/vg/robin-scripts/old_files/robin-graphs/courtyard-files/jean-combined-sv-graph/mapping-and-variant-calling-commands-for-chr6-and-full-genome.txt)