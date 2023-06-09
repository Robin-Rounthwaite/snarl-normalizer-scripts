# Input: two sam files, whose positions of reads you want to compare.
#   by convention:
#   file 1: unnormalized graph's sam
#   file 2: normalized graph's sam
# Output: a dot plot showing the positions of those reads.

# a diff between two sams containing the two sets of reads you want to compare the positions of.

#%%
import matplotlib.pyplot as plt
import numpy as np
print("hello world")


# unnorm_inf = "hg38-hsvlr_srdedup17_aug.chr6.mpmap-aln.chr6-surject.reads-mapped-between-nodes-33589074-33588890-in-unnorm.sorted.sam"
# norm_inf = "hg38-hsvlr_srdedup17_aug.chr6.normalized.mpmap-aln.chr6-surject.reads-mapped-between-nodes-33589074-33588890-in-unnorm.sorted.sam"
# minimum_chrom_pos = 469000
# maximum_chrom_pos = 470000

# #variant 5
#updated range for variant 5:
# unnorm_inf = "variant-5.updated-range.INS-len-50.12167581-12167581.data/hg38-hsvlr_srdedup17_aug.chr6.mpmap-aln.sorted.variant-5.find-nodes-33960387-33960586.gam.reads-extracted-from-unnorm-surjected.sam"
# norm_inf = "variant-5.updated-range.INS-len-50.12167581-12167581.data/hg38-hsvlr_srdedup17_aug.chr6.mpmap-aln.sorted.variant-5.find-nodes-33960387-33960586.gam.reads-extracted-from-norm-surjected.sam"
# minimum_chrom_pos = 12167000
# maximum_chrom_pos = 12168000
# minimum_mapq = 1

# #variant 4
#updated range for variant 4:
# unnorm_inf = "variant-4.updated-range.INS-len-62.7103348-7103348.data/hg38-hsvlr_srdedup17_aug.chr6.mpmap-aln.sorted.variant-4.find-nodes-33801461-33801630.gam.reads-extracted-from-unnorm-surjected.sam"
# norm_inf = "variant-4.updated-range.INS-len-62.7103348-7103348.data/hg38-hsvlr_srdedup17_aug.chr6.mpmap-aln.sorted.variant-4.find-nodes-33801461-33801630.gam.reads-extracted-from-norm-surjected.sam"
# minimum_chrom_pos = 7103200
# maximum_chrom_pos = 7103500
# minimum_mapq = 0

#variant 3
#updated range for variant 3, with the read names from unnorm:
# unnorm_inf = "variant-3.updated-range.INS-515574-515659.data/hg38-hsvlr_srdedup17_aug.chr6.mpmap-aln.sorted.variant-3.find-nodes-33590398-33590415.gam.reads-extracted-from-unnorm-surjected.sam"
# norm_inf = "variant-3.updated-range.INS-515574-515659.data/hg38-hsvlr_srdedup17_aug.chr6.mpmap-aln.sorted.variant-3.find-nodes-33590398-33590415.gam.reads-extracted-from-norm-surjected.sam"
#updated range for variant 3, with the read names from norm:
# unnorm_inf = "variant-3.updated-range.INS-515574-515659.data/hg38-hsvlr_srdedup17_aug.chr6.normalized.mpmap-aln.sorted.variant-3.find-nodes-33590398-33590415.gam.reads-extracted-from-unnorm-surjected.sam"
# norm_inf = "variant-3.updated-range.INS-515574-515659.data/hg38-hsvlr_srdedup17_aug.chr6.normalized.mpmap-aln.sorted.variant-3.find-nodes-33590398-33590415.gam.reads-extracted-from-norm-surjected.sam"
# minimum_chrom_pos = 515554
# maximum_chrom_pos = 515794
# minimum_mapq = 0

unnorm = open(unnorm_inf, "r")
norm = open(norm_inf, "r")

# experimental conditions & options
# minimum_chrom_pos = 0
# maximum_chrom_pos = 92233720368547 #int larger than human genome
minimum_chrom_pos = 12167000
maximum_chrom_pos = 12168000
minimum_mapq = 1

#code:
unnorm_mqs = list()
unnorm_pos = list()
count = 0
zero_pos_count = 0
unnorm_low_mapq_count = 0
for line in unnorm:
    count += 1
    parsed = line.split("\t")
    # if not (int(parsed[1])%512)>=256: # it's a primary alignment
    if not (int(parsed[1])%512)>=256 or (int(parsed[1])%512)>=256: # it's any kind of alignment
        if int(parsed[3]) > minimum_chrom_pos and int(parsed[3]) < maximum_chrom_pos:
            # if int(parsed[3]) > 469233 or int(parsed[3]) < 469660:
            #     unnorm_cropped_out_count += 1
            if int(parsed[4]) < minimum_mapq or int(parsed[4]) == 255:
                unnorm_low_mapq_count
            else:
                if int(parsed[3]) != 0:
                    unnorm_mqs.append(int(parsed[4])) #todo: color the dots by mapq. Maybe use normalize: https://matplotlib.org/stable/api/_as_gen/matplotlib.colors.Normalize.html#matplotlib.colors.Normalize
                    unnorm_pos.append(int(parsed[3]))
                if int(parsed[3]) == 0:
                    zero_pos_count += 1 # I guess the zero pos is a sign of no mapping location? Not sure why we have that here. All of the reads in unnorm should have at least one pos in the snarl of interest...
        # print(int(parsed[3]))
    # if count < 100:
        # print(parsed[3])

    #     break


norm_mqs = list()
norm_pos = list()
count = 0
norm_low_mapq_count = 0
for line in norm:
    count += 1
    parsed = line.split("\t")
    # if not (int(parsed[1])%512)>=256: # it's a primary alignment
    if not (int(parsed[1])%512)>=256 or (int(parsed[1])%512)>=256: # it's any kind of alignment
        if int(parsed[3]) > minimum_chrom_pos and int(parsed[3]) < maximum_chrom_pos:
            # if int(parsed[3]) > 469233 or int(parsed[3]) < 469660:
            #     norm_cropped_out_count += 1
            if int(parsed[4]) < minimum_mapq or int(parsed[4]) == 255:
                norm_low_mapq_count
            else:
                if parsed[3] != "0":
                    norm_mqs.append(int(parsed[4])) #todo: color the dots by mapq. Maybe use normalize: https://matplotlib.org/stable/api/_as_gen/matplotlib.colors.Normalize.html#matplotlib.colors.Normalize
                    norm_pos.append(int(parsed[3]))
                if parsed[3] == "0":
                    zero_pos_count += 1 # I guess the zero pos is a sign of no mapping location? Not sure why we have that here. All of the reads in unnorm should have at least one pos in the snarl of interest...

# print(unnorm_cropped_out_count)
# print(norm_cropped_out_count)

print("len(unnorm_pos)", len(unnorm_pos), "min(unnorm_pos), ", min(unnorm_pos), "max(unnorm_pos), ", max(unnorm_pos))
print("len(norm_pos)", len(norm_pos), "min(norm_pos)", min(norm_pos), "max(norm_pos)", max(norm_pos))
fig, ax = plt.subplots()
cm = plt.cm.get_cmap('RdYlBu')
ax.scatter(unnorm_pos, np.ones(len(unnorm_pos)), s=1, c=unnorm_mqs, vmin=0, vmax=60, cmap=cm)
sc = ax.scatter(norm_pos, np.zeros(len(norm_pos)), s=1, c=norm_mqs, vmin=0, vmax=60, cmap=cm)

# y = [90,40,65]
# labels = ['high', 'low', 37337]
# plt.plot(x,y, 'r')
# plt.show()

# add labels:
ratio = .1
x_left, x_right = ax.get_xlim()
y_low, y_high = ax.get_ylim()
ax.set_aspect(abs((x_right-x_left)/(y_low-y_high))*ratio)
plt.colorbar(sc)
# plt.colorbar(sc, fraction=0.046, pad = 0.04)
plt.title("Selected reads mapping start positions (mapq >=" + str(minimum_mapq) + ")")
plt.xlabel("position on chr6")
y = [0,1]
labels = ["normalized", "unnormalized"]
plt.yticks(y, labels, rotation='horizontal')

ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)
ax.spines['bottom'].set_visible(False)
ax.spines['left'].set_visible(False)

plt.show()
#%%\

print("hi")
#%%
# import numpy as np
# # Create random data
# rng = np.random.default_rng(1) # random number generator
# data = rng.integers(0, 21, size=100)
# values, counts = np.unique(data, return_counts=True)

# # Set formatting parameters based on data
# data_range = max(values)-min(values)
# width = data_range/2 if data_range<30 else 15
# height = max(counts)/3 if data_range<50 else max(counts)/4
# marker_size = 10 if data_range<50 else np.ceil(30/(data_range//10))

# # Create dot plot with appropriate format
ratio = .3
x_left, x_right = ax.get_xlim()
y_low, y_high = ax.get_ylim()
ax.set_aspect(abs((x_right-x_left)/(y_low-y_high))*ratio)
# for value, count in zip(values, counts):
#     ax.plot([value]*count, list(range(count)), marker='o', color='tab:blue',
#             ms=marker_size, linestyle='')
# for spine in ['top', 'right', 'left']:
#     ax.spines[spine].set_visible(False)
# ax.yaxis.set_visible(False)
# ax.set_ylim(-1, max(counts))
# ax.set_xticks(range(min(values), max(values)+1))
# ax.tick_params(axis='x', length=0, pad=10)

# plt.show()
# # %%

# %%
################################
#variant 2 of chr6 mpmap results:
# from 469233 to 469660
# cluster missing with reads >45 mapq >469200, <469300.
# in that cluster, we have reads moving from 469250s to 469680s. Also, a lot of the secondaries drop. See
# /home/robin/paten_lab/vg-team/vg/robin-scripts/sveval/compare-read-positions/chr6.mpmap-unpaired-end.variant-2.reads-from-469200-469300.follow-individual-read-comparisons.txt
# It was made using:

# unnorm_inf = "variant-2.DEL-469233-to-469660.data/hg38-hsvlr_srdedup17_aug.chr6.mpmap-aln.chr6-surject.reads-mapped-between-nodes-33589074-33588890-in-unnorm.sorted.sam"
# norm_inf = "variant-2.DEL-469233-to-469660.data/hg38-hsvlr_srdedup17_aug.chr6.normalized.mpmap-aln.chr6-surject.reads-mapped-between-nodes-33589074-33588890-in-unnorm.sorted.sam"
# unnorm = open(unnorm_inf, "r")
# norm = open(norm_inf, "r")

# experimental conditions & options
# minimum_chrom_pos = 469000
# maximum_chrom_pos = 470000
# minimum_mapq = 2
#

################################