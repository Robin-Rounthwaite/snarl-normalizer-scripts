#the idea is that compare-read-positions might indicate the locations of certain reads of 
# interest. 
# And then using this script, I would be able to follow those individual reads to determine where 
# they end up.
#%%
import collections as col
from sortedcontainers import SortedList

# unnorm_inf = "hg38-hsvlr_srdedup17_aug.chr6.mpmap-aln.chr6-surject.reads-mapped-between-nodes-33589074-33588890-in-unnorm.sorted.sam"
# norm_inf = "hg38-hsvlr_srdedup17_aug.chr6.normalized.mpmap-aln.chr6-surject.reads-mapped-between-nodes-33589074-33588890-in-unnorm.sorted.sam"
# unnorm = open(unnorm_inf, "r")
# norm = open(norm_inf, "r")

# #let's start by picking out reads based on if they map to the position I'm interested or not.
# # experimental conditions and options
# minimum_chrom_pos = 469200
# maximum_chrom_pos = 469300
# minimum_mapq = 45
# graph = unnorm


unnorm_inf="variant-5.INS-len-50.12167581-12167581.data/hg38-hsvlr_srdedup17_aug.chr6.mpmap-aln.sorted.variant-5.find-nodes-33960390-33960395.gam.reads-extracted-from-unnorm-surjected.sam"
norm_inf="variant-5.INS-len-50.12167581-12167581.data/hg38-hsvlr_srdedup17_aug.chr6.mpmap-aln.sorted.variant-5.find-nodes-33960390-33960395.gam.reads-extracted-from-norm-surjected.sam"

# #variant 4
# unnorm_inf="variant-4.INS-len-62.7103348-7103348.data/hg38-hsvlr_srdedup17_aug.chr6.mpmap-aln.sorted.variant-4.find-nodes-33801462-33801468.gam.reads-extracted-from-unnorm-surjected.sam"
# norm_inf="variant-4.INS-len-62.7103348-7103348.data/hg38-hsvlr_srdedup17_aug.chr6.mpmap-aln.sorted.variant-4.find-nodes-33801462-33801468.gam.reads-extracted-from-norm-surjected.sam"

#variant 3
#updated range for variant 3, with the read names from unnorm:
# unnorm_inf = "variant-3.updated-range.INS-515574-515659.data/hg38-hsvlr_srdedup17_aug.chr6.mpmap-aln.sorted.variant-3.find-nodes-33590398-33590415.gam.reads-extracted-from-unnorm-surjected.sam"
# norm_inf = "variant-3.updated-range.INS-515574-515659.data/hg38-hsvlr_srdedup17_aug.chr6.mpmap-aln.sorted.variant-3.find-nodes-33590398-33590415.gam.reads-extracted-from-norm-surjected.sam"
#updated range for variant 3, with the read names from norm:
unnorm_inf = "variant-3.updated-range.INS-515574-515659.data/hg38-hsvlr_srdedup17_aug.chr6.normalized.mpmap-aln.sorted.variant-3.find-nodes-33590398-33590415.gam.reads-extracted-from-unnorm-surjected.sam"
norm_inf = "variant-3.updated-range.INS-515574-515659.data/hg38-hsvlr_srdedup17_aug.chr6.normalized.mpmap-aln.sorted.variant-3.find-nodes-33590398-33590415.gam.reads-extracted-from-norm-surjected.sam"

# experimental conditions & options
# minimum_chrom_pos = 0
# maximum_chrom_pos = 92233720368547 #int larger than human genome
minimum_chrom_pos = 515554
maximum_chrom_pos = 515794
minimum_mapq = 0

unnorm = open(unnorm_inf, "r")
norm = open(norm_inf, "r")

# experimental conditions & options
minimum_chrom_pos = 0
maximum_chrom_pos = 92233720368547 #int larger than human genome
minimum_mapq = 45
graph = unnorm

# #code:
# interesting_read_ids = set()
# for line in graph:
#     parsed = line.split("\t")
#     if int(parsed[3]) > minimum_chrom_pos and int(parsed[3]) < maximum_chrom_pos and int(parsed[4]) >= minimum_mapq:
#         print(parsed[0])
#         interesting_read_ids.add(parsed[0])
# # %%


unnorm_full_reads = col.defaultdict(list) #key is read id, value is list of mappings associated with that read.
unnorm_reads_mapq_pos = col.defaultdict(SortedList) #key is read id, value is list of (position, mapq) pairs.
for line in unnorm:
    parsed = line.split("\t")
    if parsed[0] in interesting_read_ids:
        unnorm_full_reads[parsed[0]].append(line)
        unnorm_reads_mapq_pos[parsed[0]].add((int(parsed[3]), int(parsed[4])))

norm_full_reads = col.defaultdict(list) #key is read id, value is list of mappings associated with that read.
norm_reads_mapq_pos = col.defaultdict(SortedList) #key is read id, value is list of (position, mapq) pairs.
for line in norm:
    parsed = line.split("\t")
    if parsed[0] in interesting_read_ids:
        norm_full_reads[parsed[0]].append(line)
        norm_reads_mapq_pos[parsed[0]].add((int(parsed[3]), int(parsed[4])))


for id in unnorm_reads_mapq_pos:
    print(id)
    print("\t" + "unnorm_pos" + "\t" + "unnorm_mapq")
    for mapq_position in unnorm_reads_mapq_pos[id]:
        print("\t" + str(mapq_position[0]) + "\t" + str(mapq_position[1]))
    print()
    print("\t" + "norm_pos" + "\t" + "norm_mapq")
    for mapq_position in norm_reads_mapq_pos[id]:
        print("\t" + str(mapq_position[0]) + "\t" + str(mapq_position[1]))

#%%
#print just the reads that are different between unnorm and norm:
for id in unnorm_reads_mapq_pos:
    if unnorm_reads_mapq_pos[id] != norm_reads_mapq_pos[id]:
        print(id)
        print("\t" + "unnorm_pos" + "\t" + "unnorm_mapq")
        for mapq_position in unnorm_reads_mapq_pos[id]:
            print("\t" + str(mapq_position[0]) + "\t" + str(mapq_position[1]))
        print()
        print("\t" + "norm_pos" + "\t" + "norm_mapq")
        for mapq_position in norm_reads_mapq_pos[id]:
            print("\t" + str(mapq_position[0]) + "\t" + str(mapq_position[1]))



# %%

#for looking at individual reads full sam entry
print("unnorm reads")
for read in unnorm_full_reads["CL100076190L1C003R006_439316/2"]:
    parsed = read.split("\t")
    print()
    print(len(parsed[9]))

print()
print("norm reads")
for read in norm_full_reads["CL100076190L1C003R006_439316/2"]:
    parsed = read.split("\t")
    print()

    print(len(parsed[9]))
# %%

