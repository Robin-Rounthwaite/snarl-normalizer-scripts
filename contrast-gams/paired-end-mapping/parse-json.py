#Instructions:
#       Give python three arguments, in this order:
#       first, two compare.json files.
#       Each of these files should be given in order of: unnormalized, spoa_normalized.
#       Then, give an output file name as a third option.

#example run:
# python3.9 22-09-29.track_mapping_changes.2-graphs-only.include-mapping-nodes.py 2022-11-23.10m-reads-mapping.incl-10-secondary-alignments/2022-11-23.10m-reads.unnorm-vs-spoa.paired-end.incl-secondary-alignments.graph.compared.json 2022-11-23.10m-reads-mapping.incl-10-secondary-alignments/2022-11-23.10m-reads.unnorm-vs-spoa.paired-end.incl-secondary-alignments.graph.spoa.normalized.compared.json 2022-11-23.10m-reads-mapping.incl-10-secondary-alignments/2022-11-23.10m-reads.unnorm-vs-spoa.paired-end.incl-secondary-alignments.track-mapping-changes.txt

# python3.9 2022-12-05.track_mapping_changes.2-graphs-only.include-mapping-nodes.py 2022-11-23.10m-reads-mapping.incl-10-secondary-alignments/2022-11-23.10m-reads.unnorm-vs-spoa.paired-end.incl-secondary-alignments.graph.compared.json 2022-11-23.10m-reads-mapping.incl-10-secondary-alignments/2022-11-23.10m-reads.unnorm-vs-spoa.paired-end.incl-secondary-alignments.graph.spoa.normalized.compared.json 2022-11-23.10m-reads-mapping.incl-10-secondary-alignments/2022-12-05.10m-reads.unnorm-vs-spoa.paired-end.incl-secondary-alignments.track-mapping-changes.separate-mapping-entries.with-refpos.txt && python3.9 2022-12-02.analyze-mapping-changes.separate-mapping-entries.corrected-position-and-formatting.py 2022-11-23.10m-reads-mapping.incl-10-secondary-alignments/2022-12-05.10m-reads.unnorm-vs-spoa.paired-end.incl-secondary-alignments.track-mapping-changes.separate-mapping-entries.with-refpos.txt 2022-12-05.analyze-mapping-changes.separate-mapping-entries.corrected-position-and-formatting.with-refpos

#to run the test:
# python track_mapping_changes.2-graphs-only.include-mapping-nodes.interleave-mappings.py /home/robin/paten_lab/vg-team/vg/robin-graphs/courtyard-files/22-09-20.spoa-nygc-chr21/track_mapping_changes/buggy-2023-01-09/test-track-mapping-changes.input-data.compared.json /home/robin/paten_lab/vg-team/vg/robin-graphs/courtyard-files/22-09-20.spoa-nygc-chr21/track_mapping_changes/buggy-2023-01-09/test-track-mapping-changes.input-data.compared.json /home/robin/paten_lab/vg-team/vg/robin-graphs/courtyard-files/22-09-20.spoa-nygc-chr21/track_mapping_changes/buggy-2023-01-09/test-track-mapping-changes.testing-output-data.txt 

# example running in tandem with analyze_mapping_changes:
# python3.9 2023-01-10.track_mapping_changes.2-graphs-only.include-mapping-nodes.interleave-mappings.py 2022-11-23.10m-reads-mapping.incl-10-secondary-alignments/2022-11-23.10m-reads.unnorm-vs-spoa.paired-end.incl-secondary-alignments.graph.compared.json 2022-11-23.10m-reads-mapping.incl-10-secondary-alignments/2022-11-23.10m-reads.unnorm-vs-spoa.paired-end.incl-secondary-alignments.graph.spoa.normalized.compared.json 2022-11-23.10m-reads-mapping.incl-10-secondary-alignments/2022-11-23.10m-reads.unnorm-vs-spoa.paired-end.incl-secondary-alignments.2023-01-10.track-mapping-changes.txt && echo "moving to analyze" && python3.9 2023-01-09.2.analyze-mapping-changes.separate-mapping-entries.interleave-mappings.py 2022-11-23.10m-reads-mapping.incl-10-secondary-alignments/2022-11-23.10m-reads.unnorm-vs-spoa.paired-end.incl-secondary-alignments.2023-01-10.track-mapping-changes.txt 2022-12-08.10m-reads.10-secondaries.updated-vg/2023-01-10.2022-12-13.track_mapping_changes.2-graphs-only.include-mapping-nodes.interleave-mappings.output.analyze-mappings

#goal: set up two dicionaries: 
#       1) a dictionary for mapping qualities 
#       2) a dictionary for mapping accuracy (correct or incorrect).
# each with a read name for each key and a list of three numbers corresponding to values from the three graphs
#       (chr21 unnormalized/spoa_normalized/spoa_batch_normalized).

# to get mapping accuracies, I think we need to consult the start/end positions on the path, and 
#       compare them to the truth set gam. 

import collections as col
import json
import sys
    # Zephyrus test files:
    # in_compare = open("/home/robin/paten_lab/vg-team/vg/robin-graphs/courtyard-files/22-09-20.spoa-nygc-chr21/track_mapping_changes.trial-data.json", "r")
    # in_gaf = open("/home/robin/paten_lab/vg-team/vg/robin-graphs/courtyard-files/22-09-20.spoa-nygc-chr21/filter-gam-script/chunk_9_chr21_5033737_5034091.gaf", "r")



compares = [sys.argv[1], sys.argv[2]]
compare_names = ["unnormalized", "normalized"]
read_mappings = dict() #key: read_name, value: dict(key: is either "unnormalized_primary", "unnormalized_secondary", "normalized_primary", or "normalized_secondary".
                                                   #value: list of paired_mappings. For the primary mappings, can only be a list of up to size 1. (and I expect it to always be exactly 1)
for compare, compare_name in zip(compares, compare_names):
    print("opening file ", compare, "and labeling it as", compare_name)
    with open(compare) as inf:
        line_count = 0
        #list of length two, one for each of the reads in the paired read.
        #each read will be a dictionary, with keys "mapping_quality", "correctly_mapped", "path", and "reference_position"

        #TODO: remake paired_mappings.
        # paired_mapping = ["NA", "NA"] 
        for line in inf:
            data = json.loads(line)

            #determine if mapping is secondary or primary:
            is_secondary = False
            if "is_secondary" in data.keys() and bool(data["is_secondary"])==True:
                is_secondary = True
                
            #determine root of read name (no _1 or _2, indicating which of a pair it is)
            name_root = data["name"][:-2]

            paired_number = int(data["name"][-1]) #either 1 or 2

            if line_count%1000000 == 0:
                print("currently at line", line_count)
            line_count += 1

            #get path from json
            path = list()
            if "path" in data.keys():
                for edit in data["path"]["mapping"]:
                    path.append(int(edit["position"]["node_id"]))
                    
            #get all positions on the reference.
            reference_position = list()
            if "refpos" in data.keys():
                for pos in data["refpos"]:
                    if pos["name"] == "chr21":
                        reference_position.append(int(pos["offset"]))

            # add the mapping to the paired_mapping.
            mapping = dict(mapping_quality = int(data["mapping_quality"]) if ("mapping_quality" in data.keys()) else "NA",
                           correctly_mapped = bool(data["correctly_mapped"]) if ("correctly_mapped" in data.keys()) else "NA",
                           path = path,
                           reference_position = reference_position
                           ) 
            
            ## Insert into read_mappings.
            if name_root not in read_mappings:
                read_mappings[name_root] = dict()
                read_mappings[name_root]["unnormalized_primary"] = list(["NA", "NA"])
                read_mappings[name_root]["unnormalized_secondary"] = list()
                read_mappings[name_root]["normalized_primary"] = list(["NA", "NA"])
                read_mappings[name_root]["normalized_secondary"] = list()
                
            if is_secondary == False:
                # we know that there should be only one primary mapping per read, so I can
                # confidently insert this mapping into the (paired_number - 1)th position 
                # of the read pair.
                # however, if there is a duplicate primary mapping, alert the user via terminal.
                if read_mappings[name_root][compare_name + "_primary"][paired_number - 1] != "NA":
                    print("WARNING: overwriting primary mapping", data["name"][:-2], ".")
                    print("Original mapping: ")
                    print(str(read_mappings[name_root][compare_name + "_primary"][paired_number - 1]))
                    print("New mapping: ")
                    print(mapping)

                read_mappings[name_root][compare_name + "_primary"][paired_number - 1] = mapping
                
            if is_secondary == True:
                # look for the first read pair with a slot open in (paired_number - 1)th position.
                # if there are no mappings yet, make the first slot.
                if len(read_mappings[name_root][compare_name + "_secondary"]) == 0:
                    read_mappings[name_root][compare_name + "_secondary"].append(["NA", "NA"])
                    
                # look for the first open slot in a paired end mapping to put our read.
                #TODO: change the convention for compared.json so I can *know* which read is paired with which.
                found_empty = False
                for pair_i in range(len(read_mappings[name_root][compare_name + "_secondary"])):
                    pair = read_mappings[name_root][compare_name + "_secondary"][pair_i]
                    if pair[paired_number - 1] == "NA": #then it is an empty slot. Fill it.
                        read_mappings[name_root][compare_name + "_secondary"][pair_i][paired_number - 1] = mapping
                        found_empty = True
                        break

                # if we never found an empty slot to put our mapping, make a new pair and put our mapping in that.
                if found_empty == False:
                    read_mappings[name_root][compare_name + "_secondary"].append(["NA", "NA"])
                    read_mappings[name_root][compare_name + "_secondary"][-1][paired_number - 1] = mapping
        

# save the dictionary one paired_mapping per line.
with open(sys.argv[3], "w") as outf:
    for read_name, paired_mapping in read_mappings.items():
        outf.write(read_name + "\t" + str(paired_mapping) + "\n")
