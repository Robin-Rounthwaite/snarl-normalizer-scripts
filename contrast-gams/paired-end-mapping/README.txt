

Order to call scripts:

1) parse-json.py (originally from "~/paten_lab/vg-team/vg/robin-scripts/old_files/robin-graphs/courtyard-files/22-09-20.spoa-nygc-chr21/track_mapping_changes.2-graphs-only.include-mapping-nodes.interleave-mappings.py")
2) aggregate-mappings-by-mapq-and-accuracy.py (originally from "/home/robin/paten_lab/vg-team/vg/robin-scripts/old_files/robin-graphs/courtyard-files/22-09-20.spoa-nygc-chr21/track_mapping_changes/analyze-mapping-changes.separate-mapping-entries.interleave-mappings.flexible-change-in-mapq.py")
3) visualize-mapping-changes.py (originally from "~/paten_lab/vg-team/vg/robin-scripts/old_files/robin-graphs/courtyard-files/22-09-20.spoa-nygc-chr21/track_mapping_changes")

Example outline:
python parse-json.py in-unnormalized-compared.json in-normalized-compared.json out-unnorm-norm.parsed-json.txt
python aggregate-mappings-by-mapq-and-accuracy.py out-unnorm-norm.parsed-json.txt outfile_prefix
python visualize-mapping-changes.py --a outfile_prefix/file -u unnorm-graph.xg -n norm-graph.xg -f unnorm.gam -g norm.gam -o outfile_prefix/ 

Example, on Courtyard:
cd /public/groups/vg/rrounthw/22-09-20.spoa-nygc-chr21/
#the scripts are not in the above directory at the time of writing. Thus, you need to replace the tool directories in the example to call them.
#e.g. script-dir=snarl-normalizer-scripts/contrast-gams/paired-end-mapping/

python script-dir/parse-json.py 2022-11-23.10m-reads-mapping.incl-10-secondary-alignments/2022-11-23.10m-reads.unnorm-vs-spoa.paired-end.incl-secondary-alignments.graph.compared.json 2022-11-23.10m-reads-mapping.incl-10-secondary-alignments/2022-11-23.10m-reads.unnorm-vs-spoa.paired-end.incl-secondary-alignments.graph.spoa.normalized.compared.json 2022-11-23.10m-reads-mapping.incl-10-secondary-alignments/parsed-json.unnormalized-vs-spoa-normalized.txt && python3.9 2022-12-02.analyze-mapping-changes.separate-mapping-entries.corrected-position-and-formatting.py 2022-11-23.10m-reads-mapping.incl-10-secondary-alignments/2022-12-05.10m-reads.unnorm-vs-spoa.paired-end.incl-secondary-alignments.track-mapping-changes.separate-mapping-entries.with-refpos.txt

.... (I didn't finish writing example. But you can follow along a real example by looking at the comments at the top of each file)
python script-dir/aggregate-mappings-by-mapq-and-accuracy.py 