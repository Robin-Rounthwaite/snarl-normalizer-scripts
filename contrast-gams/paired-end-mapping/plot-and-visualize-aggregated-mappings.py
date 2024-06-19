#an alternative to visualize-mapping-changes.py that plots all the interesting mapping changes found in aggregate-mappings-by-mapq-and-accuracy.py so that mapq change is x-value and accuracy change is y-value
# and the final mapq of the read is color
# and points are transparent (as detailed in the question (not the answer) here: https://stackoverflow.com/questions/30108372/how-to-make-matplotlib-scatterplots-transparent-as-a-group) so that the overlapping points are still visible, at least up to the point that the color is saturated.
# Maybe also make the points be merged and made larger if they are identical in quality?

# reminder of what aggregated-mappings call looks like in my script:
#aggregate-mappings-by-mapq-and-accuracy.py out-unnorm-norm.${REFORMATTED}.parsed-json.txt ${OUTPUT_DIR}/aggregated_mappings/${KEYWORD}



#hmmm. Actually, would a better way to show this... be to have each read given two points with an arrow showing how the read changed in both mapq and accuracy before/after normalization?
# maybe two subplots, like this:
#https://stackoverflow.com/questions/60807792/arrows-between-subplots
import matplotlib.pyplot as plt

fig = plt.figure()

# First subplot
ax1 = fig.add_subplot(121)
plt.plot([0, 1], [0, 1]) 

# Second subplot
ax2 = fig.add_subplot(122)
plt.plot([0, 1], [0, 1]) 

# Add line from one subplot to the other
xyA = [0.5, 1.0]
ax1.plot(*xyA, "o")
xyB = [0.75, 0.25]
ax2.plot(*xyB, "o")
# ConnectionPatch handles the transform internally so no need to get fig.transFigure
arrow = patches.ConnectionPatch(
    xyA,
    xyB,
    coordsA=ax1.transData,
    coordsB=ax2.transData,
    # Default shrink parameter is 0 so can be omitted
    color="black",
    arrowstyle="-|>",  # "normal" arrow
    mutation_scale=30,  # controls arrow head size
    linewidth=3,
)
fig.patches.append(arrow)

# Show figure
plt.show()