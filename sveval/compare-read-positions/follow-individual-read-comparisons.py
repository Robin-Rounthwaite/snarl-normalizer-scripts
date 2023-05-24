#the idea is that compare-read-positions might indicate the locations of certain reads of 
# interest. 
# And then using this script, I would be able to follow those individual reads to determine where 
# they end up.
#%%
import collections as col
from sortedcontainers import SortedList


#%%
unnorm_inf = "hg38-hsvlr_srdedup17_aug.chr6.mpmap-aln.chr6-surject.reads-mapped-between-nodes-33589074-33588890-in-unnorm.sorted.sam"
norm_inf = "hg38-hsvlr_srdedup17_aug.chr6.normalized.mpmap-aln.chr6-surject.reads-mapped-between-nodes-33589074-33588890-in-unnorm.sorted.sam"
unnorm = open(unnorm_inf, "r")
norm = open(norm_inf, "r")

#let's start by picking out reads based on if they map to the position I'm interested or not.
# experimental conditions and options
map_pos_min = 469200
map_pos_max = 469300
minimum_mapq = 45
graph = unnorm

#code:
interesting_read_ids = set()
for line in graph:
    parsed = line.split("\t")
    if int(parsed[3]) > map_pos_min and int(parsed[3]) < map_pos_max and int(parsed[4]) >= minimum_mapq:
        print(parsed[0])
        interesting_read_ids.add(parsed[0])
# %%
unnorm_inf = "hg38-hsvlr_srdedup17_aug.chr6.mpmap-aln.chr6-surject.reads-mapped-between-nodes-33589074-33588890-in-unnorm.sorted.sam"
norm_inf = "hg38-hsvlr_srdedup17_aug.chr6.normalized.mpmap-aln.chr6-surject.reads-mapped-between-nodes-33589074-33588890-in-unnorm.sorted.sam"
unnorm = open(unnorm_inf, "r")
norm = open(norm_inf, "r")

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


# %%
for id in unnorm_reads_mapq_pos:
    print(id)
    print("\t" + "unnorm_pos" + "\t" + "unnorm_mapq")
    for mapq_position in unnorm_reads_mapq_pos[id]:
        print("\t" + str(mapq_position[0]) + "\t" + str(mapq_position[1]))
    print()
    print("\t" + "norm_pos" + "\t" + "norm_mapq")
    for mapq_position in norm_reads_mapq_pos[id]:
        print("\t" + str(mapq_position[0]) + "\t" + str(mapq_position[1]))
    
# %%
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

