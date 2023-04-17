#give two arguments: infile.track-mapping-changes.txt outfile_prefix
#calling example:
# python /home/robin/paten_lab/vg-team/vg/robin-graphs/courtyard-files/22-09-20.spoa-nygc-chr21/track_mapping_changes/analyze-mapping-changes.separate-mapping-entries.interleave-mappings.py track_mapping_changes/analyze-mapping-changes.separate-mapping-entries.interleave-mappings.testing-data.txt track_mapping_changes/test.analyze-mapping-changes.txt


import sys
import ast


def namestr(obj, namespace):
    return [name for name in namespace if namespace[name] is obj]

def place_in_dicts(mapping, high_mapq_threshold, unnorm_accuracy, norm_accuracy, unnorm_mapq, norm_mapq):
    if norm_mapq - unnorm_mapq >= high_mapq_change_threshold:
        # the mapping is gaining_mapq.
        if norm_accuracy - unnorm_accuracy > 0:
            gaining_mapq["gaining_accuracy"].append(mapping)
        elif norm_accuracy - unnorm_accuracy < 0:
            gaining_mapq["dropping_accuracy"].append(mapping)
        elif norm_accuracy == 0: #from this elif downwards both norm_accuracy and unnorm_accuracy must be equivalent...
            gaining_mapq["inaccurate_to_inaccurate"].append(mapping)
        elif norm_accuracy == 0.5:
            gaining_mapq["half_accurate_to_half_accurate"].append(mapping)
        elif norm_accuracy == 1:
            gaining_mapq["accurate_to_accurate"].append(mapping)
        else:
            print("found a bad accuracy field. accuracy fields:", norm_accuracy, unnorm_accuracy, "mapping:", mapping)

    elif 0-(norm_mapq - unnorm_mapq) >=high_mapq_change_threshold:
        # the mapping is dropping_mapq.
        if norm_accuracy - unnorm_accuracy > 0:
            dropping_mapq["gaining_accuracy"].append(mapping)
        elif norm_accuracy - unnorm_accuracy < 0:
            dropping_mapq["dropping_accuracy"].append(mapping)
        elif norm_accuracy == 0: #from this elif downwards both norm_accuracy and unnorm_accuracy must be equivalent...
            dropping_mapq["inaccurate_to_inaccurate"].append(mapping)
        elif norm_accuracy == 0.5:
            dropping_mapq["half_accurate_to_half_accurate"].append(mapping)
        elif norm_accuracy == 1:
            dropping_mapq["accurate_to_accurate"].append(mapping)
        else:
            print("found a bad accuracy field. accuracy fields:", norm_accuracy, unnorm_accuracy, "mapping:", mapping)

    else:
        #the mapping is either a maintaining_high_mapq or maintaining_low_mapq mapping.
        if unnorm_mapq >= high_mapq_threshold and norm_mapq >= high_mapq_threshold:
        # if norm_mapq - unnorm_mapq > high_mapq_change_threshold:
            if norm_accuracy - unnorm_accuracy > 0:
                maintaining_high_mapq["gaining_accuracy"].append(mapping)
            elif norm_accuracy - unnorm_accuracy < 0:
                maintaining_high_mapq["dropping_accuracy"].append(mapping)
            elif norm_accuracy == 0: #from this elif downwards both norm_accuracy and unnorm_accuracy must be equivalent...
                maintaining_high_mapq_count["inaccurate_to_inaccurate"] += 1
            elif norm_accuracy == 0.5:
                maintaining_high_mapq_count["half_accurate_to_half_accurate"] += 1
            elif norm_accuracy == 1:
                maintaining_high_mapq_count["accurate_to_accurate"] += 1
            else:
                print("found a bad accuracy field. accuracy fields:", norm_accuracy, unnorm_accuracy, "mapping:", mapping)
        # maintaining low mapq:
        if unnorm_mapq < high_mapq_threshold and norm_mapq < high_mapq_threshold:
        # if norm_mapq - unnorm_mapq > high_mapq_change_threshold:
            if norm_accuracy - unnorm_accuracy > 0:
                maintaining_low_mapq_count["gaining_accuracy"] += 1
            elif norm_accuracy - unnorm_accuracy < 0:
                maintaining_low_mapq_count["dropping_accuracy"] += 1
            elif norm_accuracy == 0: #from this elif downwards both norm_accuracy and unnorm_accuracy must be equivalent...
                maintaining_low_mapq_count["inaccurate_to_inaccurate"] += 1
            elif norm_accuracy == 0.5:
                maintaining_low_mapq_count["half_accurate_to_half_accurate"] += 1
            elif norm_accuracy == 1:
                maintaining_low_mapq_count["accurate_to_accurate"] += 1
            else:
                print("found a bad accuracy field. accuracy fields:", norm_accuracy, unnorm_accuracy, "mapping:", mapping)
    
    if norm_mapq - unnorm_mapq < 0:
        # we had a read lose mapq overall. Log this information.
        mapq_loss_in_reads_lose_mapq.append(norm_mapq-unnorm_mapq)
        if 0-(norm_mapq-unnorm_mapq) == 60:
            losses["loss_60"] += 1
        if 0-(norm_mapq-unnorm_mapq) >= 30 and 0-(norm_mapq-unnorm_mapq) < 60:
            losses["loss_30"] += 1
        if 0-(norm_mapq-unnorm_mapq) >= 15 and 0-(norm_mapq-unnorm_mapq) < 30:
            losses["loss_15"] += 1
        if 0-(norm_mapq-unnorm_mapq) >= 1 and 0-(norm_mapq-unnorm_mapq) < 15:
            losses["loss_1"] += 1
    if norm_mapq - unnorm_mapq > 0:
        # we had a read gain mapq overall. Log this information.
        mapq_gains_in_reads_gain_mapq.append(norm_mapq-unnorm_mapq)
        if norm_mapq-unnorm_mapq == 60:
            gains["gains_60"] += 1
        if norm_mapq-unnorm_mapq >= 30 and norm_mapq-unnorm_mapq < 60:
            gains["gains_30"] += 1
        if norm_mapq-unnorm_mapq >= 15 and norm_mapq-unnorm_mapq < 30:
            gains["gains_15"] += 1
        if norm_mapq-unnorm_mapq >= 1 and norm_mapq-unnorm_mapq < 15:
            gains["gains_1"] += 1

high_mapq_change_threshold = 10
high_mapq_threshold = 30

mapq_loss_in_reads_lose_mapq = list()
losses = dict(loss_60 = int(), loss_30 = int(), loss_15 = int(), loss_1 = int())
mapq_gains_in_reads_gain_mapq = list()
gains = dict(gains_60 = int(), gains_30 = int(), gains_15 = int(), gains_1 = int())

#lists for interesting reads, sorted by mapq
dropping_mapq = dict(accurate_to_accurate=list(), dropping_accuracy=list(), gaining_accuracy=list(), inaccurate_to_inaccurate=list(), half_accurate_to_half_accurate=list())
gaining_mapq = dict(accurate_to_accurate=list(), dropping_accuracy=list(), gaining_accuracy=list(), inaccurate_to_inaccurate=list(), half_accurate_to_half_accurate=list())
maintaining_high_mapq = dict(dropping_accuracy=list(), gaining_accuracy=list())
# some fields aren't as interesting. Let's just count these, instead of appending them to lists.
maintaining_high_mapq_count = dict(accurate_to_accurate=int(), inaccurate_to_inaccurate=int(), half_accurate_to_half_accurate=int())
maintaining_low_mapq_count = dict(accurate_to_accurate=int(), dropping_accuracy=int(), gaining_accuracy=int(), inaccurate_to_inaccurate=int(), half_accurate_to_half_accurate=int())

### Read in data:
print("reading in data")
# inf = open("track_mapping_changes/2022-12-01.10m-reads.unnorm-vs-spoa.paired-end.incl-secondary-alignments.track-mapping-changes.separate-mapping-entries.txt")
line_count = 0
with open(sys.argv[1]) as inf:
    for line in inf:
        if line_count%1000000 == 0:
            print("analyzing line #", line_count)
        line_count += 1
        #TODO: if one of the pair of the paired mapping is an int, that means that the read did not have a mapped paired end. Skip it, I guess?? 
        #convert line to mapping entry (a dictionary with two values: "unnormalized" and "normalized", each with a list of mappings in those categories).
        mapping_name = line.split("\t")[0]
        mappings = ast.literal_eval(line.split("\t")[1])
        mapqs_unnormalized = list()
        mapqs_normalized = list()
        mapqs_count_unnormalized = int()
        mapqs_count_normalized = int()
        accuracies_unnormalized = list()
        accuracies_normalized = list()
        accuracies_count_unnormalized = int()
        accuracies_count_normalized = int()
        unnormalized_mapping_keys = ["unnormalized_primary", "unnormalized_secondary"]
        normalized_mapping_keys = ["normalized_primary", "normalized_secondary"]
        # unfortunately, because of a mistake I missed in track_mapping_changes where I 
        # didn't make a nested list for _primary mappings, I have to write separate 
        # for loops for each of the different types of mappings.
                            # pair_mapq = list()
                            # pair_accuracy = list()
                            # for mapping_end in mappings["unnormalized_primary"]:
                            #     if mapping_end not in [0, 1]: #skip the non-mappings:
                            #         #todo: QUESTION: will mapping qualities differ across the two pairs in a paired end read? This is something to test for.
                            #         # if (mapping_end["mapping_quality"] != "NA"):
                            #         #     pair_mapq.append(mapping_end["mapping_quality"])
                            #         #     mapqs_count_unnormalized += 1
                                        
                            #         if (mapping_end["correctly_mapped"] != "NA"):
                            #             pair_accuracy.append(mapping_end["correctly_mapped"])
                            #             accuracies_count_unnormalized += 1
                            #         else:
                            #             pair_accuracy.append(False)
                            #             accuracies_count_unnormalized += 1
                            #         # print("pair_accuracy unnorm", pair_accuracy)
                            # mapqs_unnormalized.append(pair_mapq)
                            # accuracies_unnormalized.append(pair_accuracy)
                            # for mapping in mappings["unnormalized_secondary"]:
                            #     pair_mapq = list()
                            #     for mapping_end in mapping:
                            #         if mapping_end not in [0, 1]: #skip the non-mappings:
                            #             #todo: QUESTION: will mapping qualities differ across the two pairs in a paired end read? This is something to test for.
                            #             if (mapping_end["mapping_quality"] != "NA"):
                            #                 pair_mapq.append(mapping_end["mapping_quality"])
                            #                 mapqs_count_unnormalized += 1
                                            
                            #             # pair_accuracy = list()
                            #             # if (mapping_end["correctly_mapped"] != "NA"):
                            #             #     pair_accuracy.append(mapping_end["correctly_mapped"])
                            #             #     accuracies_count_unnormalized += 1
                            #             # else:
                            #             #     pair_accuracy.append(False)
                            #             #     accuracies_count_unnormalized += 1
                            # mapqs_unnormalized.append(pair_mapq)
                            # # accuracies_unnormalized.append(pair_accuracy)
                            # pair_mapq = list()
                            # pair_accuracy = list()
                            # for mapping_end in mappings["normalized_primary"]:
                            #     if mapping_end not in [0, 1]: #skip the non-mappings:
                            #         #todo: QUESTION: will mapping qualities differ across the two pairs in a paired end read? This is something to test for.
                            #         if (mapping_end["mapping_quality"] != "NA"):
                            #             pair_mapq.append(mapping_end["mapping_quality"])
                            #             mapqs_count_normalized += 1
                                        
                            #         if (mapping_end["correctly_mapped"] != "NA"):
                            #             pair_accuracy.append(mapping_end["correctly_mapped"])
                            #             accuracies_count_normalized += 1
                            #         else:
                            #             pair_accuracy.append(False)
                            #             accuracies_count_normalized += 1
                            #         # print("pair_accuracy norm", pair_accuracy)
                            # mapqs_normalized.append(pair_mapq)
                            # accuracies_normalized.append(pair_accuracy)

                            # for mapping in mappings["normalized_secondary"]:
                            #     pair_mapq = list()
                            #     for mapping_end in mapping:
                            #         if mapping_end not in [0, 1]: #skip the non-mappings:
                            #             #todo: QUESTION: will mapping qualities differ across the two pairs in a paired end read? This is something to test for.
                            #             if (mapping_end["mapping_quality"] != "NA"):
                            #                 pair_mapq.append(mapping_end["mapping_quality"])
                            #                 mapqs_count_normalized += 1
                                            
                            #             # pair_accuracy = list()
                            #             # if (mapping_end["correctly_mapped"] != "NA"):
                            #             #     pair_accuracy.append(mapping_end["correctly_mapped"])
                            #             #     accuracies_count_normalized += 1
                            #             # else:
                            #             #     pair_accuracy.append(False)
                            #             #     accuracies_count_normalized += 1
                            # mapqs_normalized.append(pair_mapq)
                            # # accuracies_normalized.append(pair_accuracy)
                            
                            # if mapqs_count_unnormalized == 0:
                            #     mapqs_unnormalized_avg = 0
                            # else:
                            #     mapqs_unnormalized_avg = sum(sum(pair) for pair in mapqs_unnormalized)/(2*mapqs_count_unnormalized) #2* because it's a pair we need to average over.
                            # if mapqs_count_normalized == 0:
                            #     mapqs_normalized_avg = 0
                            # else:
                            #     print("list of mapqs_normalized:", mapqs_normalized)
                            #     mapqs_normalized_avg = sum(sum(pair) for pair in mapqs_normalized)/(2*mapqs_count_normalized)
                            # if accuracies_count_unnormalized == 0:
                            #     accurate_unnormalized = 0
                            # else:
                            #     # accuracies_unnormalized_avg = sum(sum(pair) for pair in accuracies_unnormalized)/accuracies_count_unnormalized
                            #     # accurate_unnormalized measures whether we ever got a mapping with both, one, or none of the pairs mapped accurately.
                            #     # todo: the problem with this is that we could get exactly one of the pair mapped accurately in unnormalized, 
                            #     #   and the exact other one of the pair mapped accurately in normalized, and it would look like the 
                            #     #   amount of mapping accuracy stayed the same before/after normalization. While this edge case would 
                            #     #   probably be interesting, in the interest of time I'm going to skip it for now. 
                            #     accurate_unnormalized = max(sum(pair) for pair in accuracies_unnormalized)/2
                            # if accuracies_count_normalized == 0:
                            #     accurate_normalized = 0
                            # else:
                            #     # accuracies_normalized_avg = sum(sum(pair) for pair in accuracies_normalized)/accuracies_count_normalized
                            #     # accurate_normalized measures whether we ever got a mapping with both, one, or none of the pairs mapped accurately.
                            #     # todo: the problem with this is that we could get exactly one of the pair mapped accurately in unnormalized, 
                            #     #   and the exact other one of the pair mapped accurately in normalized, and it would look like the 
                            #     #   amount of mapping accuracy stayed the same before/after normalization. While this edge case would 
                            #     #   probably be interesting, in the interest of time I'm going to skip it for now. 
                            #     accurate_normalized = max(sum(pair) for pair in accuracies_normalized)/2
        # print("accuracies_unnormalized", accuracies_unnormalized)
        # print("accuracies_normalized", accuracies_normalized)
        # print("mapqs_unnormalized_avg", mapqs_unnormalized_avg)
        # print("mapqs_normalized_avg", mapqs_normalized_avg)
        # place_in_dicts(mapping_name + "\t" + str(mappings), high_mapq_threshold, accurate_unnormalized, accurate_normalized, mapqs_unnormalized_avg, mapqs_normalized_avg)

        # vars_to_check_for_NA = [unnormalized_primary_correctly_mapped_0, unnormalized_primary_correctly_mapped_1, normalized_primary_correctly_mapped_0, normalized_primary_correctly_mapped_1, unnormalized_primary_mapq_0, unnormalized_primary_mapq_1, normalized_primary_mapq_0, normalized_primary_mapq_1, ]

        # unnormalized_primary_correctly_mapped_0 = bool()
        # if mappings["unnormalized_primary"][0]["correctly_mapped"] == "NA":
        #     unnormalized_primary_correctly_mapped_0 = False
        # else:
        #     unnormalized_primary_correctly_mapped_0 = mappings["unnormalized_primary"][0]["correctly_mapped"]
        # unnormalized_primary_correctly_mapped_1 = bool()
        # if mappings["unnormalized_primary"][1]["correctly_mapped"] == "NA":
        #     unnormalized_primary_correctly_mapped_1 = False
        # else:
        #     unnormalized_primary_correctly_mapped_1 = mappings["unnormalized_primary"][1]["correctly_mapped"]
        # normalized_primary_correctly_mapped_0 = bool()
        # if mappings["normalized_primary"][0]["correctly_mapped"] == "NA":
        #     normalized_primary_correctly_mapped_0 = False
        # else:
        #     normalized_primary_correctly_mapped_0 = mappings["normalized_primary"][0]["correctly_mapped"]
        # normalized_primary_correctly_mapped_1 = bool()
        # if mappings["normalized_primary"][1]["correctly_mapped"] == "NA":
        #     normalized_primary_correctly_mapped_1 = False
        # else:
        #     normalized_primary_correctly_mapped_1 = mappings["normalized_primary"][1]["correctly_mapped"]


        unnormalized_primary_correctly_mapped_0 = False if mappings["unnormalized_primary"][0]["correctly_mapped"] == "NA" else mappings["unnormalized_primary"][0]["correctly_mapped"]
        unnormalized_primary_correctly_mapped_1 = False if mappings["unnormalized_primary"][1]["correctly_mapped"] == "NA" else mappings["unnormalized_primary"][1]["correctly_mapped"]
        normalized_primary_correctly_mapped_0 = False if mappings["normalized_primary"][0]["correctly_mapped"] == "NA" else mappings["normalized_primary"][0]["correctly_mapped"]
        normalized_primary_correctly_mapped_1 = False if mappings["normalized_primary"][1]["correctly_mapped"] == "NA" else mappings["normalized_primary"][1]["correctly_mapped"]
        unnormalized_primary_mapping_quality_0 = False if mappings["unnormalized_primary"][0]["mapping_quality"] == "NA" else mappings["unnormalized_primary"][0]["mapping_quality"]
        unnormalized_primary_mapping_quality_1 = False if mappings["unnormalized_primary"][1]["mapping_quality"] == "NA" else mappings["unnormalized_primary"][1]["mapping_quality"]
        normalized_primary_mapping_quality_0 = False if mappings["normalized_primary"][0]["mapping_quality"] == "NA" else mappings["normalized_primary"][0]["mapping_quality"]
        normalized_primary_mapping_quality_1 = False if mappings["normalized_primary"][1]["mapping_quality"] == "NA" else mappings["normalized_primary"][1]["mapping_quality"]
        
        accurate_unnormalized = (unnormalized_primary_correctly_mapped_0 + unnormalized_primary_correctly_mapped_1)/2
        accurate_normalized = (normalized_primary_correctly_mapped_0 + normalized_primary_correctly_mapped_1)/2
        mapqs_unnormalized_avg = (unnormalized_primary_mapping_quality_0 + unnormalized_primary_mapping_quality_1)/2 #todo: decide if I want to keep this as is or half it. Probably half it.
        mapqs_normalized_avg = (normalized_primary_mapping_quality_0 + normalized_primary_mapping_quality_1)/2
        place_in_dicts((mapping_name, mappings), high_mapq_threshold, accurate_unnormalized, accurate_normalized, mapqs_unnormalized_avg, mapqs_normalized_avg)

print("finished the analysis. Outputting to file:")

outfile_prefix = sys.argv[2]

### Record analysis
print()
print("Size of saved fields:")
for (dict_name, read_dict) in [("dropping_mapq", dropping_mapq), ("gaining_mapq", gaining_mapq), ("maintaining_high_mapq", maintaining_high_mapq)]:
    print()
    print(dict_name)
    for field, reads in read_dict.items():
        if dict_name == "gaining_mapq" or dict_name == "maintaining_high_mapq":
            #sort the gaining mapq reads by the higher mapq in the comparison: the normalized reads.
            #(also, arbitrarily, sort the maintaining_high_mapq reads the same way).
            reads.sort(key = lambda read: (read[1]["normalized_primary"][0]["mapping_quality"] + read[1]["normalized_primary"][1]["mapping_quality"]), reverse=True)
            #todo: uncomment (and possibly debug) the following line, which sorts first based on the above criterion, then sorts based on the unnormalized_primary mapqs in counting-up order (i.e. reverse=False for the unnormalized_primary mapq sorting).
            # reads.sort(key = lambda read: (read[1]["normalized_primary"][0]["mapping_quality"] + read[1]["normalized_primary"][1]["mapping_quality"], -(read[1]["unnormalized_primary"][0]["mapping_quality"] + read[1]["unnormalized_primary"][1]["mapping_quality"])), reverse=True)
        else: #dict_name == dropping_mapq:
            #sort the dropping mapq reads by the higher mapq in the comparison: the unnormalized reads.
            reads.sort(key = lambda read: (read[1]["unnormalized_primary"][0]["mapping_quality"] + read[1]["unnormalized_primary"][1]["mapping_quality"]), reverse=True)

        # print("field", field, "reads", reads)
        print("\t", field, len(reads))
        # save relevant data fields, each to their own file.
        if len(reads) > 0:
            outf = open(outfile_prefix + "." + dict_name + "." + field + ".txt", "w")
            # print("reads", reads)
            for read in reads:
                outf.write(read[0] + "\t" + str(read[1]) + "\n")
            outf.close()

print()
print("Size of unsaved fields:")
for (dict_name, read_dict) in [("maintaining_high_mapq_count", maintaining_high_mapq_count), ("maintaining_low_mapq_count", maintaining_low_mapq_count)]:
    print()
    print(dict_name)
    for field, read_count in read_dict.items():
        print("\t", field, read_count)

print()
if len(mapq_loss_in_reads_lose_mapq) == 0:
    print("avg mapq_loss_in_reads_lose_mapq", "N/A")
else:
    print("avg mapq_loss_in_reads_lose_mapq", sum(mapq_loss_in_reads_lose_mapq)/len(mapq_loss_in_reads_lose_mapq))
print("loss of mapq >= 60", losses["loss_60"])
print("loss of mapq >= 30 but <60", losses["loss_30"])
print("loss of mapq >= 15 but <30", losses["loss_15"])
print("loss of mapq >= 01 but <15", losses["loss_1"])

print()
if len(mapq_gains_in_reads_gain_mapq) == 0:
    print("avg mapq_gains_in_reads_gain_mapq", "N/A")
else:
    print("avg mapq_gains_in_reads_gain_mapq", sum(mapq_gains_in_reads_gain_mapq)/len(mapq_gains_in_reads_gain_mapq))
print("gains of mapq >= 60", gains["gains_60"])
print("gains of mapq >= 30 but <60", gains["gains_30"])
print("gains of mapq >= 15 but <30", gains["gains_15"])
print("gains of mapq >= 01 but <15", gains["gains_1"])




